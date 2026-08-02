package Net::APNS::SimpleCert;
use 5.008001;
use strict;
use warnings;
use Carp ();
use JSON;
use Moo;
use Protocol::HTTP2::Client;
use IO::Select;
use IO::Socket::SSL qw();

our $VERSION = "0.04";

has [qw/cert key development/] => (
    is => 'rw',
);

has apns_expiration => (
    is => 'rw',
    default => 0,
);

has apns_priority => (
    is => 'rw',
    default => 10,
);

sub algorithm {'ES256'}

sub _host {
    my ($self) = @_;
    return 'api.' . ($self->development ? 'development.' : '') . 'push.apple.com'
}

sub _port {443}

sub _socket {
    my ($self) = @_;
    if (!$self->{_socket} || !$self->{_socket}->opened){
        # TLS transport socket
        $self->{_socket} = IO::Socket::SSL->new(
            PeerHost => $self->_host,
            PeerPort => $self->_port,
            # openssl 1.0.1 support only NPN
            SSL_npn_protocols => ['h2'],
            # openssl 1.0.2 also have ALPN
            SSL_alpn_protocols => ['h2'],
            SSL_version => 'TLSv1_2',
            # for certificate authentication
            SSL_cert_file => $self->cert,
            SSL_key_file => $self->key,
        ) or die $! || $IO::Socket::SSL::SSL_ERROR;

        # non blocking
        $self->{_socket}->blocking(0);
    }
    return $self->{_socket};
}

sub _client {
    my ($self) = @_;
    $self->{_client} ||= Protocol::HTTP2::Client->new(keepalive => 1);
    return $self->{_client};
}

sub prepare {
    my ($self, $device_token, $payload, $cb) = @_;
   my $path = sprintf '/3/device/%s', $device_token;
    push @{$self->{_request}}, {
        ':scheme' => 'https',
        ':authority' => join(":", $self->_host, $self->_port),
        ':path' => $path,
        ':method' => 'POST',
        headers => [
            'apns-expiration' => $self->apns_expiration,
            'apns-priority' => $self->apns_priority,
        ],
        data => JSON::encode_json($payload),
        on_done => $cb,
    };
    return $self;
}

sub _make_client_request_single {
    my ($self) = @_;
    if (my $req = shift @{$self->{_request}}){
        my $done_cb = delete $req->{on_done};
        $self->_client->request(
            %$req,
            on_done => sub {
                ref $done_cb eq 'CODE'
                    and $done_cb->(@_);
                $self->_make_client_request_single();
            },
        );
    }
    else {
        $self->_client->close;
    }
}

sub notify {
    my ($self) = @_;
    # request one by one as APNS server returns SETTINGS_MAX_CONCURRENT_STREAMS = 1
    $self->_make_client_request_single();
    my $io = IO::Select->new($self->_socket);
    # send/recv frames until request is done
    while ( !$self->_client->shutdown ) {
        $io->can_write;
        while ( my $frame = $self->_client->next_frame ) {
            syswrite $self->_socket, $frame;
        }
        $io->can_read;
        while ( sysread $self->_socket, my $data, 4096 ) {
            $self->_client->feed($data);
        }
    }
    undef $self->{_client};
    $self->_socket->close(SSL_ctx_free => 1);
}

1;
__END__

=encoding utf-8

=head1 NAME

Net::APNS::SimpleCert - APNS Perl implementation

=head1 DESCRIPTION

A Perl implementation for sending notifications via APNS using Apple's new HTTP/2 API.
This library uses Protocol::HTTP2::Client as http2 backend.
And it also supports multiple stream at one connection.
(It does not correspond to parallel stream because APNS server returns SETTINGS_MAX_CONCURRENT_STREAMS = 1.)

=head1 SYNOPSIS

    use Net::APNS::SimpleCert;

    my $apns = Net::APNS::SimpleCert->new(
        # enable if development
        # development => 1,
        cert => '/path/to/certificate.pem',
        key => '/path/to/key.pem',
        apns_expiration => 0,
        apns_priority => 10,
    );

    # 1st request
    $apns->prepare('DEVICE_ID',{
            aps => {
                alert => 'APNS message: HELLO!',
                badge => 1,
                sound => "default",
                # SEE: https://developer.apple.com/jp/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/TheNotificationPayload.html,
            },
        }, sub {
            my ($header, $content) = @_;
            require Data::Dumper;
            print Dumper $header;

            # $VAR1 = [
            #           ':status',
            #           '200',
            #           'apns-id',
            #           '791DE8BA-7CAA-B820-BD2D-5B12653A8DF3'
            #         ];

            print Dumper $content;

            # $VAR1 = undef;
        }
    );

    # 2nd request
    $apns->prepare(...);

    # also supports method chain
    # $apns->prepare(1st request)->prepare(2nd request)....

    # send notification
    $apns->notify();

=head1 METHODS

=head2 my $apns = Net::APNS::SimpleCert->new(%arg)

=over

=item development : bool

Switch API's URL to 'api.development.push.apple.com' if enabled.

=item cert : string

Path to Apple push notification certificate.

=item key : string

Path to Apple push notification certificate's private key.

=item apns_expiration : number

Default 0.

=item apns_priority : number

Default 10.

=back

    All properties can be accessed as Getter/Setter like `$apns->development`.

=head2 $apns->prepare($DEVICE_ID, $PAYLOAD);

Prepare notification.
It is possible to specify more than one. Please do before invoking notify method.

    $apns->prepare(1st request)->prepare(2nd request)....

Payload please refer: https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/PayloadKeyReference.html#//apple_ref/doc/uid/TP40008194-CH17-SW1.

=head2 $apns->notify();

Execute notification.
Multiple notifications can be executed with one SSL connection.

=head1 LICENSE

Based on Net::APNS::Simple, Copyright (C) Tooru Tsurukawa.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Tooru Tsurukawa E<lt>rockbone.g at gmail.comE<gt>
Modifications by Matthew Powell E<lt>matthew at atom.netE<gt>

https://github.com/rockbone/p5-Net-APNS-Simple

=cut

