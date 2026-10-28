require ["vnd.dovecot.pipe", "copy", "imapsieve", "environment", "variables"];

if environment :matches "imap.email" "*" {
  set "email" "${1}";
}

pipe :copy "train-spam.sh" [ "${email}" ];
