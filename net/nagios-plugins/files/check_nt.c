/******************************************************************************
 *  
 * CHECK_NT.C -modified from official plugins version 1.4 beta1 
 *									downloaded on Jan 30,2005
 *
 * Program: Windows NT plugin for Nagios
 * License: GPL
 * Copyright (c) 2000-2002 Yves Rubin (rubiyz@yahoo.com)
 *
 * Description:
 * 
 * This requires NSClient software to run on NT (http://nsclient.ready2run.nl/)
 *
 * License Information:
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * $Id: check_nt.c,v 1.24 2005/04/23 11:54:01 amontibello Exp $
 *
 *****************************************************************************/

const char *progname = "check_nc_net";
const char *revision = "$Revision: 1.24 $";
const char *copyright = "2003-2005";
const char *email = "nagiosplug-devel@lists.sourceforge.net";

#include "common.h"
#include "netutils.h"
#include "utils.h"

enum checkvars {
	CHECK_NONE,
	CHECK_CLIENTVERSION,
	CHECK_CPULOAD,
	CHECK_UPTIME,
	CHECK_USEDDISKSPACE,
	CHECK_FREEDISKSPACE,
	CHECK_SERVICESTATE,
	CHECK_PROCSTATE,
	CHECK_MEMUSE,
	CHECK_COUNTER,
	CHECK_FILEAGE,
	CHECK_INSTANCES,
	CHECK_EVENTLOG,
	CHECK_WMICHECK,
	CHECK_CONFIG,
	ENUM_CONFIG,
	ENUM_PASSIVE,
	/* ADDPASSIVE - is implemented as a switch -S */
	CONFIG_DELPASSIVE,
	ENUM_PROCESS,
	ENUM_SERVICE,
	CHECK_WMICOUNTER,
	ENUM_COUNTER,
	ENUM_COUNTERDESC,
	CHECK_WMICAT
};

enum {
	MAX_VALUE_LIST = 30,
	PORT = 1248
};

char *server_address=NULL;
char *volume_name=NULL;
int server_port=PORT;
char *value_list=NULL;
char *req_password=NULL;
char *service_desc=NULL;
char *check_type=NULL;
unsigned long lvalue_list[MAX_VALUE_LIST];
unsigned long warning_value=0L;
unsigned long critical_value=0L;
int check_warning_value=FALSE;
int check_critical_value=FALSE;
char *critical_value_string=NULL;
char *warning_value_string=NULL;
enum checkvars vars_to_check = CHECK_NONE;
int show_all=FALSE;
int add_passive_check=FALSE;
/*change buffer size from MAX_INPUT_BUFFER to 4096*/
char recv_buffer[4096];

void fetch_data (const char* address, int port, const char* sendb);
int process_arguments(int, char **);
void preparelist(char *string);
void preparelist2(char *string, char c);
int strtoularray(unsigned long *array, char *string, const char *delim);
void print_help(void);
void print_usage(void);
void print_command( char * opts);

int main(int argc, char **argv){

/* should be 	int result = STATE_UNKNOWN; */

	int return_code = STATE_UNKNOWN;
	char *send_buffer=NULL;
	char *output_message=NULL;
	char *perfdata=NULL;
	char *temp_string=NULL;
	char *temp_string_perf=NULL;
	char *description=NULL,*counter_unit = NULL;
	char *minval = NULL, *maxval = NULL, *errcvt = NULL;

	double total_disk_space=0;
	double free_disk_space=0;
	double percent_used_space=0;
	double warning_used_space=0;
	double critical_used_space=0;
	double mem_commitLimit=0;
	double mem_commitByte=0;
	double fminval = 0, fmaxval = 0;
	unsigned long utilization;
	unsigned long uptime;
	unsigned long age_in_minutes;
	double counter_value = 0.0;
	int offset=0;
	int updays=0;
	int uphours=0;
	int upminutes=0;

	int isPercent = FALSE;
	int allRight = FALSE;

	setlocale (LC_ALL, "");
	bindtextdomain (PACKAGE, LOCALEDIR);
	textdomain (PACKAGE);

	if(process_arguments(argc,argv) == ERROR)
		usage4 (_("Could not parse arguments"));

	/* initialize alarm signal handling */
	signal(SIGALRM,socket_timeout_alarm_handler);

	/* set socket timeout */
	alarm(socket_timeout);

	if ( add_passive_check == TRUE ) {
		asprintf(&send_buffer, "%s&98", req_password); /* Tells NC_Net to add to passive.cfg */
		/*each concatination to original string is a paired set based on args entered*/
		asprintf(&send_buffer, "%s&%s&%s", send_buffer, check_type,service_desc );
		if (check_warning_value==TRUE ) { /* check for warning*/
			asprintf(&send_buffer, "%s&-w&%s", send_buffer, warning_value_string );
		}
		if (check_critical_value==TRUE ) { /* check for critical*/
			asprintf(&send_buffer, "%s&-c&%s", send_buffer, critical_value_string );
		}
		if ( value_list != NULL ) {
			asprintf(&send_buffer, "%s&-l&%s", send_buffer, value_list );
		}
		if ( vars_to_check== CHECK_SERVICESTATE|| vars_to_check ==CHECK_PROCSTATE  ) {
			if (show_all==TRUE) asprintf(&send_buffer, "%s&-d&SHOWALL", send_buffer );
			else	asprintf(&send_buffer, "%s&-d&SHOWFAIL", send_buffer );
		}
		fetch_data (server_address, server_port, send_buffer);
/*		asprintf (&output_message, "Running addpassive check -S: %s -v: %s",service_desc,check_type );*/
		return_code=atoi(strtok(recv_buffer,"&"));
		temp_string=strtok(NULL,"&");
		output_message = strdup (temp_string);
	}
	else  /* run Switch statment*/
	switch (vars_to_check) {

	case CHECK_CLIENTVERSION:

		asprintf(&send_buffer, "%s&1", req_password);
		fetch_data (server_address, server_port, send_buffer);
		if (value_list != NULL && strcmp(recv_buffer, value_list) != 0) {
			asprintf (&output_message, _("Wrong client version - running: %s, required: %s"), recv_buffer, value_list);
			return_code = STATE_WARNING;
		} else {
			asprintf (&output_message, "%s", recv_buffer);
			return_code = STATE_OK;
		}
		break;

	case CHECK_CPULOAD:

		if (value_list==NULL)
			output_message = strdup (_("missing -l parameters"));
		else if (strtoularray(lvalue_list,value_list,",")==FALSE)
			output_message = strdup (_("wrong -l parameter."));
		else {
			/* -l parameters is present with only integers */
			return_code=STATE_OK;
			temp_string = strdup (_("CPU Load"));
			temp_string_perf = strdup (" ");
      
			/* loop until one of the parameters is wrong or not present */
			while (lvalue_list[0+offset]> (unsigned long)0 &&
						 lvalue_list[0+offset]<=(unsigned long)17280 && 
						 lvalue_list[1+offset]> (unsigned long)0 &&
						 lvalue_list[1+offset]<=(unsigned long)100 && 
						 lvalue_list[2+offset]> (unsigned long)0 &&
						 lvalue_list[2+offset]<=(unsigned long)100) {

				/* Send request and retrieve data */
				asprintf(&send_buffer,"%s&2&%lu",req_password,lvalue_list[0+offset]);
				fetch_data (server_address, server_port, send_buffer);

				utilization=strtoul(recv_buffer,NULL,10);
				
				/* Check if any of the request is in a warning or critical state */
				if(utilization >= lvalue_list[2+offset])
					return_code=STATE_CRITICAL;
				else if(utilization >= lvalue_list[1+offset] && return_code<STATE_WARNING)
					return_code=STATE_WARNING;

				asprintf(&output_message,_(" %lu%% (%lu min average)"), utilization, lvalue_list[0+offset]);
				asprintf(&temp_string,"%s%s",temp_string,output_message);
				asprintf(&perfdata,_(" '%lu min avg Load'=%lu%%;%lu;%lu;0;100"), lvalue_list[0+offset], utilization,
				  lvalue_list[1+offset], lvalue_list[2+offset]);
				asprintf(&temp_string_perf,"%s%s",temp_string_perf,perfdata);
				offset+=3;	/* move across the array */
			}
      
			if (strlen(temp_string)>10) {  /* we had at least one loop */
				output_message = strdup (temp_string);
				perfdata = temp_string_perf;
			} else
				output_message = strdup (_("not enough values for -l parameters"));
		}	
		break;

	case CHECK_UPTIME:

		asprintf(&send_buffer, "%s&3", req_password);
		fetch_data (server_address, server_port, send_buffer);
		uptime=strtoul(recv_buffer,NULL,10);
		updays = uptime / 86400; 			
		uphours = (uptime % 86400) / 3600;
		upminutes = ((uptime % 86400) % 3600) / 60;
		asprintf(&output_message,_("System Uptime - %u day(s) %u hour(s) %u minute(s)"),updays,uphours, upminutes);
		return_code=STATE_OK;
		break;

	case CHECK_USEDDISKSPACE:
    case CHECK_FREEDISKSPACE:

		if (value_list==NULL)
			output_message = strdup (_("missing -l parameters"));
		else if (strlen(value_list)!=1)
			output_message = strdup (_("wrong -l argument"));
		else {
			asprintf(&send_buffer,"%s&4&%s", req_password, value_list);
			fetch_data (server_address, server_port, send_buffer);
			free_disk_space=atof(strtok(recv_buffer,"&"));
			total_disk_space=atof(strtok(NULL,"&"));
			percent_used_space = ((total_disk_space - free_disk_space) / total_disk_space) * 100;
			warning_used_space = ( warning_value > 100 )?warning_value*1024.0*1024:(warning_value*1.0 / 100) * total_disk_space;
			critical_used_space = ( critical_value > 100 )?critical_value*1024.0*1024:(critical_value*1.0 / 100) * total_disk_space;
			if (free_disk_space>=0) {
				asprintf(&temp_string,_("%s: - total: %.2f Gb - used: %.2f Gb (%.0f%%) - free %.2f Gb (%.0f%%)"),
				  value_list, total_disk_space / 1073741824, (total_disk_space - free_disk_space) / 1073741824,
				  percent_used_space, free_disk_space / 1073741824, (free_disk_space / total_disk_space)*100);
				asprintf(&temp_string_perf,_("'%s: Used Space'=%.2fGb;%.2f;%.2f;0.00;%.2f"), value_list,
				  (total_disk_space - free_disk_space) / 1073741824, warning_used_space / 1073741824,
				  critical_used_space / 1073741824, total_disk_space / 1073741824);
				return_code=STATE_OK;	
				if (check_warning_value==TRUE ) { 
					if (vars_to_check==CHECK_FREEDISKSPACE) {
						if ( free_disk_space < warning_used_space ) { return_code=STATE_WARNING; }
					}else { /* test useddiskspace*/
						if ( total_disk_space - free_disk_space > warning_used_space ) { return_code=STATE_WARNING; }
					}
				}
				if (check_critical_value==TRUE ) { 
					if (vars_to_check==CHECK_FREEDISKSPACE) {
						if ( free_disk_space < critical_used_space ) { return_code=STATE_CRITICAL; }
					}else { /* test useddiskspace*/
						if ( total_disk_space - free_disk_space > critical_used_space ) { return_code=STATE_CRITICAL; }
					}
				}
				output_message = strdup (temp_string);
				perfdata = temp_string_perf;
			} else {
				output_message = strdup (_("Free disk space : Invalid drive "));
				return_code=STATE_UNKNOWN;
			}
		}
		break;

	case CHECK_SERVICESTATE:
	case CHECK_PROCSTATE:

		if (value_list==NULL)
			output_message = strdup (_("No service/process specified"));
		else {
			preparelist(value_list);		/* replace , between services with & to send the request */
			asprintf(&send_buffer,"%s&%u&%s&%s", req_password,(vars_to_check==CHECK_SERVICESTATE)?5:6,
							 (show_all==TRUE) ? "ShowAll" : "ShowFail",value_list);
			fetch_data (server_address, server_port, send_buffer);
			return_code=atoi(strtok(recv_buffer,"&"));
			temp_string=strtok(NULL,"&");
			output_message = strdup (temp_string);
		}
		break;

	case CHECK_MEMUSE:
		
		asprintf(&send_buffer,"%s&7", req_password);
		fetch_data (server_address, server_port, send_buffer);
		mem_commitLimit=atof(strtok(recv_buffer,"&"));
		mem_commitByte=atof(strtok(NULL,"&"));
		percent_used_space = (mem_commitByte / mem_commitLimit) * 100;
		warning_used_space = ((float)warning_value / 100) * mem_commitLimit;
		critical_used_space = ((float)critical_value / 100) * mem_commitLimit;

		/* Divisor should be 1048567, not 3044515, as we are measuring "Commit Charge" here, 
		which equals RAM + Pagefiles. */
		asprintf(&output_message,_("Memory usage: total:%.2f Mb - used: %.2f Mb (%.0f%%) - free: %.2f Mb (%.0f%%)"), 
		  mem_commitLimit / 1048567, mem_commitByte / 1048567, percent_used_space,  
		  (mem_commitLimit - mem_commitByte) / 1048567, (mem_commitLimit - mem_commitByte) / mem_commitLimit * 100);
		asprintf(&perfdata,_("'Memory usage'=%.2fMb;%.2f;%.2f;0.00;%.2f"), mem_commitByte / 1048567,
		  warning_used_space / 1048567, critical_used_space / 1048567, mem_commitLimit / 1048567);
	
		return_code=STATE_OK;
		if(check_critical_value==TRUE && percent_used_space >= critical_value)
			return_code=STATE_CRITICAL;
		else if (check_warning_value==TRUE && percent_used_space >= warning_value)
			return_code=STATE_WARNING;	

		break;

	case CHECK_COUNTER:
		/* 
		Check_Counter has been rewriten for NC_Net now it processes the pref data in 
		a more consistent way to the Nagios plug-in development guidelines. 

		1) if no Units of mesurement use a 0 (zero) for the UOM  in the check 
		and the units will be omited from the output.

		2) it will do MIN without a MAX

		3) still processes custom min and max even if it is %

		4) % has a default of min 0, max 100

		5) -w and -c are no longer causing a seg fault. old code said to always
		process both for perf data, but it should have checked that they were in use.
		
		6) the description is only a label for perf data not a formatter...   
       		
		*/
      		if (value_list == NULL)
			output_message = strdup (_("No counter specified"));
      		else {
	  		preparelist (value_list);	/* replace , between services with & to send the request */

	  		temp_string = strtok (value_list, "&");
	 		isPercent = (strchr (temp_string, '%') != NULL);
	  		description = strtok (NULL, "&");
	  		counter_unit = strtok (NULL, "&");
	  		asprintf (&send_buffer, "%s&8&%s", req_password, value_list);
	  		fetch_data (server_address, server_port, send_buffer);
	  		counter_value = atof (recv_buffer);
			if (isPercent)	counter_unit = strdup ("%");
			if ( description != NULL && counter_unit == NULL )
				counter_unit = strdup ( "0" );
			if ( counter_unit != NULL && description != NULL) 
	    		{	
				if ( counter_unit[0] == '0' ) counter_unit[0] = '\0';
				minval = strtok (NULL, "&");
	      			maxval = strtok (NULL, "&");
				if ( minval == NULL && isPercent ) asprintf(&minval,"0");
				if ( minval != NULL ) fminval = strtod ( minval, NULL ) ;
				if ( maxval == NULL && isPercent ) asprintf(&maxval,"100");
				if ( maxval != NULL ) 	fmaxval = strtod (maxval, NULL);
				allRight = TRUE;
	      			/* Let's format the output string, finally... */
				asprintf (&output_message, "%s = %.2f %s", description, counter_value, counter_unit);
	      			asprintf (&output_message,"%s | %s", output_message, 
						fperfdata (description, counter_value, 
							counter_unit, check_warning_value, warning_value,
						       	check_critical_value, critical_value,
							(minval != NULL), fminval,
				   			(maxval != NULL), fmaxval  ));
			}
			else if (isPercent)
				asprintf(&output_message, "%s = %.2f %%",temp_string,counter_value);
			else
				asprintf(&output_message, "%s = %.2f",temp_string,counter_value);
		}
      		if (critical_value > warning_value)
		{			/* Normal thresholds */
	  		if (check_critical_value == TRUE && counter_value >= critical_value)
	    		     return_code = STATE_CRITICAL;
	  		else if (check_warning_value == TRUE && counter_value >= warning_value)
	    			return_code = STATE_WARNING;
	  		     else
	    			return_code = STATE_OK;
		}
      		else
		{			/* inverse thresholds */
	  		return_code = STATE_OK;
	  		if (check_critical_value == TRUE && counter_value <= critical_value)
	    		     return_code = STATE_CRITICAL;
	  		else if (check_warning_value == TRUE && counter_value <= warning_value)
				    return_code = STATE_WARNING;
		}
        break;
		
	case CHECK_FILEAGE:

		if (value_list==NULL)
			output_message = strdup (_("No file specified"));
		else {
			preparelist(value_list);		/* replace , between services with & to send the request */
			asprintf(&send_buffer,"%s&9&%s", req_password,value_list);
			fetch_data (server_address, server_port, send_buffer);
			age_in_minutes = atoi(strtok(recv_buffer,"&"));
			description = strtok(NULL,"&");
			/* output message modified as per several requests */
			/* output_message = strdup (description);  */
	
			if (critical_value > warning_value) {        /* Normal thresholds */
				if(check_critical_value==TRUE && age_in_minutes >= critical_value) 
					return_code=STATE_CRITICAL;
				else if (check_warning_value==TRUE && age_in_minutes >= warning_value)
					return_code=STATE_WARNING;	
				else
					return_code=STATE_OK;	
			} 
			else {                                       /* inverse thresholds */
				if(check_critical_value==TRUE && age_in_minutes <= critical_value)
					return_code=STATE_CRITICAL;
				else if (check_warning_value==TRUE && age_in_minutes <= warning_value)
					return_code=STATE_WARNING;	
				else
					return_code=STATE_OK;	
			}
			if ( return_code == STATE_OK ) 
				asprintf ( &output_message,"OK: %u Minutes, %s", age_in_minutes, value_list);
			else if ( return_code == STATE_WARNING ) 
				asprintf ( &output_message,"WARNING: %u Minutes, %s", age_in_minutes, value_list);
			else if ( return_code == STATE_CRITICAL ) 
				asprintf ( &output_message,"CRITICAL: %u Minutes, %s", age_in_minutes, value_list);
			else
				output_message = strdup (description);

		}
		break;

	case CHECK_INSTANCES:

		if (value_list==NULL)
			output_message = strdup (_("No Perfomance counter Category specified"));
		else {
			preparelist(value_list);
 			asprintf(&send_buffer,"%s&10&%s", req_password,value_list);
 			fetch_data (server_address, server_port, send_buffer);
 			asprintf (&output_message, "%s", recv_buffer);
 			return_code = STATE_OK;
		}
		break;

	case CHECK_EVENTLOG:

		if (value_list==NULL)
			asprintf(&send_buffer,"%s&11", req_password);
		else {
			asprintf(&send_buffer,"%s&11&%s", req_password,value_list);
		}
		fetch_data (server_address, server_port, send_buffer);
		return_code=atoi(strtok(recv_buffer,"&"));
		temp_string=strtok(NULL,"&");
		if(check_critical_value==TRUE &&  return_code >= critical_value)
			return_code=STATE_CRITICAL;
		else if (check_warning_value==TRUE && return_code >= warning_value)
			return_code=STATE_WARNING;	
		else if (check_warning_value==TRUE || check_critical_value==TRUE) 
			return_code=STATE_OK;	
		else if ( return_code == 0 )
			return_code = STATE_OK;
		else if ( return_code != STATE_OK )
			return_code=STATE_CRITICAL;
		output_message = strdup (temp_string);
		break;

	
	case CHECK_WMICHECK:

		if (value_list==NULL)
			output_message = strdup (_("No Query specified"));
		else {
			preparelist2(value_list,'^');
			asprintf(&send_buffer, "%s&12&%s", req_password,value_list);
			fetch_data (server_address, server_port, send_buffer);
			asprintf (&output_message, "%s", recv_buffer);
			return_code = STATE_OK;
		}
		break;

	case CHECK_CONFIG:

		if (value_list==NULL)
			output_message = strdup (_("missing -l parameters"));
		else {
			preparelist(value_list);/* replace , between parameters with & to send the request */
			asprintf(&send_buffer,"%s&99&%s", req_password,value_list);
			fetch_data (server_address, server_port, send_buffer);
			asprintf (&output_message, "%s", recv_buffer);
			return_code = STATE_OK;
		}
		break;

	case ENUM_CONFIG:
		asprintf(&send_buffer,"%s&18", req_password);
		fetch_data (server_address, server_port, send_buffer);
		asprintf (&output_message, "%s", recv_buffer);
		return_code = STATE_OK;
		break;

	case ENUM_PASSIVE:
		asprintf(&send_buffer,"%s&19", req_password);
		fetch_data (server_address, server_port, send_buffer);
		asprintf (&output_message, "%s", recv_buffer);
		return_code = STATE_OK;
		break;

	case CONFIG_DELPASSIVE:
		if (value_list==NULL)
			output_message = strdup (_("missing -l parameters"));
		else {
			asprintf(&send_buffer,"%s&97&%s", req_password, value_list);
			fetch_data (server_address, server_port, send_buffer);
			return_code=atoi(strtok(recv_buffer,"&"));
			temp_string=strtok(NULL,"&");
			output_message = strdup (temp_string);
		}
		break;

	case ENUM_PROCESS:
		asprintf(&send_buffer,"%s&17", req_password);
		fetch_data (server_address, server_port, send_buffer);
		asprintf (&output_message, "%s", recv_buffer);
		return_code = STATE_OK;
		break;

	case ENUM_SERVICE:
		
		if ( value_list == NULL )
			asprintf(&send_buffer,"%s&16&all", req_password);
		else {
			preparelist(value_list);
			asprintf(&send_buffer,"%s&16&%s", req_password,value_list);
		}
		fetch_data (server_address, server_port, send_buffer);
		asprintf (&output_message, "%s", recv_buffer);
		return_code = STATE_OK;
		break;

	case ENUM_COUNTER:
		if ( value_list == NULL )
			asprintf(&send_buffer,"%s&15", req_password);
		else {
			preparelist(value_list);
			asprintf(&send_buffer,"%s&15&%s", req_password,value_list);
		}
		fetch_data (server_address, server_port, send_buffer);
		asprintf (&output_message, "%s", recv_buffer);
		return_code = STATE_OK;
		break;

	case CHECK_WMICOUNTER:
		/* requires -d input showall for checking against max showfail check against min */
		if (value_list==NULL)
			output_message = strdup (_("No Query specified"));
		else {
			preparelist2(value_list,'^');
			if ( show_all == FALSE ) /*&& warning_value > critical_value )*/
				asprintf(&send_buffer, "%s&14&SHOWFAIL&%s", req_password,value_list);
			else asprintf(&send_buffer, "%s&14&SHOWALL&%s", req_password,value_list);
			fetch_data (server_address, server_port, send_buffer);
			asprintf (&output_message, "%s", recv_buffer);
			counter_value =atof(output_message);
			return_code = STATE_OK;
			if ( show_all == TRUE ) { /* returned a max value*/
				asprintf (&output_message, "%s \n%f Showall ", output_message, counter_value);
				if (check_warning_value == TRUE && counter_value >= atof(warning_value_string) ){
	    			return_code = STATE_WARNING;
				}
				if (check_critical_value == TRUE && counter_value >= atof(critical_value_string)){
	    		    return_code = STATE_CRITICAL;
				}
			}else {  /* returned a min value */
				asprintf (&output_message, "%s \n%f Showfail ", output_message, counter_value );
				if (check_warning_value == TRUE && counter_value <= atof(warning_value_string) ){
	    			return_code = STATE_WARNING;
				}
				if (check_critical_value == TRUE && counter_value <= atof(critical_value_string) ){
	    		     return_code = STATE_CRITICAL;
				}
			}
		}
		break;

	case ENUM_COUNTERDESC:
		if ( value_list == NULL )
			output_message = strdup (_("-l missing, no category specified."));
		else {
			preparelist(value_list);
			asprintf(&send_buffer,"%s&20&%s", req_password,value_list);
		}
		fetch_data (server_address, server_port, send_buffer);
		asprintf (&output_message, "%s", recv_buffer);
		return_code = STATE_OK;
		break;

	case CHECK_WMICAT:

		if (value_list==NULL)
			output_message = strdup (_("No Query specified"));
		else {
			preparelist2(value_list,'^');
			asprintf(&send_buffer, "%s&21&%s", req_password,value_list);
			fetch_data (server_address, server_port, send_buffer);
			asprintf (&output_message, "%s", recv_buffer);
			return_code = STATE_OK;
		}
		break;

	case CHECK_NONE:
	default:
		usage4 (_("Please specify a variable to check"));
		break;

	}

	/* reset timeout */
	alarm(0);

	if (perfdata==NULL)
		printf("%s\n",output_message);
	else
		printf("%s | %s\n",output_message,perfdata);
	return return_code;
}



/* process command-line arguments */
int process_arguments(int argc, char **argv){
	int c;

	int option = 0;
	static struct option longopts[] =
	{ 
		{"port",     required_argument,0,'p'},
		{"timeout",  required_argument,0,'t'},
		{"critical", required_argument,0,'c'},
		{"warning",  required_argument,0,'w'},
		{"variable", required_argument,0,'v'},
		{"addpassive", required_argument,0,'S'},
		{"hostname", required_argument,0,'H'},
		{"version",  no_argument,      0,'V'},
		{"help",     optional_argument,0,'h'},
		{0,0,0,0}
	};

	/* no options were supplied */
	if(argc<2) return ERROR;


	/* change default timeout to 20 seconds */
	socket_timeout = 20;

	/* backwards compatibility */
	if (! is_option(argv[1])) {
		server_address = strdup(argv[1]);
		argv[1]=argv[0];
		argv=&argv[1];
		argc--;
	}

  for (c=1;c<argc;c++) {
    if(strcmp("-to",argv[c])==0)
      strcpy(argv[c],"-t");
    else if (strcmp("-wv",argv[c])==0)
      strcpy(argv[c],"-w");
    else if (strcmp("-cv",argv[c])==0)
      strcpy(argv[c],"-c");
	}

	while (1){
		c = getopt_long(argc,argv,"+hVH:S:t:c:w:p:v:l:s:d:",longopts,&option);

		if (c==-1||c==EOF||c==1)
			break;

		switch (c)
			{
			case '?': /* print short usage statement if args not parsable */
			usage2 (_("Unknown argument"), optarg);
			case 'h': /* help */
				if ( optarg == NULL ) {
					print_help();
					exit(STATE_OK);
				} 
				else { /*print help on single command*/
					print_command(optarg);
					exit(STATE_OK);
				}
			case 'V': /* version */
				print_revision(progname,revision);
				exit(STATE_OK);
			case 'H': /* hostname */
				if (server_address)	free(server_address);
				server_address = optarg;
				break;
			case 's': /* password */
				req_password = optarg;
				break;
			case 'p': /* port */
				if (is_intnonneg(optarg))
					server_port=atoi(optarg);
				else
					die(STATE_UNKNOWN,_("Server port must be an integer\n"));
				break;
			case 'S': /* service_descriptio */
				service_desc = optarg;
				add_passive_check = TRUE;
				break;
			case 'v':
				if(strlen(optarg)<4)
					return ERROR;
				check_type = optarg;
				if(!strcmp(optarg,"CLIENTVERSION"))
					vars_to_check=CHECK_CLIENTVERSION;
				else if(!strcmp(optarg,"CPULOAD"))
					vars_to_check=CHECK_CPULOAD;
				else if(!strcmp(optarg,"UPTIME"))
					vars_to_check=CHECK_UPTIME;
				else if(!strcmp(optarg,"USEDDISKSPACE"))
					vars_to_check=CHECK_USEDDISKSPACE;
				else if(!strcmp(optarg,"SERVICESTATE"))
					vars_to_check=CHECK_SERVICESTATE;
				else if(!strcmp(optarg,"PROCSTATE"))
					vars_to_check=CHECK_PROCSTATE;
				else if(!strcmp(optarg,"MEMUSE"))
					vars_to_check=CHECK_MEMUSE;
				else if(!strcmp(optarg,"COUNTER"))
					vars_to_check=CHECK_COUNTER;
				else if(!strcmp(optarg,"FILEAGE"))
					vars_to_check=CHECK_FILEAGE;
				else if(!strcmp(optarg,"INSTANCES"))
					vars_to_check=CHECK_INSTANCES;
				else if(!strcmp(optarg,"EVENTLOG"))
					vars_to_check=CHECK_EVENTLOG;
				else if(!strcmp(optarg,"WMICHECK"))
					vars_to_check=CHECK_WMICHECK;
				else if(!strcmp(optarg,"FREEDISKSPACE"))
					vars_to_check=CHECK_FREEDISKSPACE;
				else if(!strcmp(optarg,"CONFIG"))
					vars_to_check=CHECK_CONFIG;
				else if(!strcmp(optarg,"ENUMCONFIG"))  
					vars_to_check=ENUM_CONFIG;
				else if(!strcmp(optarg,"ENUMPASSIVE"))  
					vars_to_check=ENUM_PASSIVE;
				else if(!strcmp(optarg,"DELPASSIVE"))  
					vars_to_check=CONFIG_DELPASSIVE;
				else if(!strcmp(optarg,"ENUMPROCESS"))  
					vars_to_check=ENUM_PROCESS;
				else if(!strcmp(optarg,"ENUMSERVICE"))  
					vars_to_check=ENUM_SERVICE;
				else if(!strcmp(optarg,"WMICOUNTER"))  
					vars_to_check=CHECK_WMICOUNTER;
				else if(!strcmp(optarg,"ENUMCOUNTER"))  
					vars_to_check=ENUM_COUNTER;
				else if(!strcmp(optarg,"ENUMCOUNTERDESC"))  
					vars_to_check=ENUM_COUNTERDESC;
				else if(!strcmp(optarg,"WMICAT"))  
					vars_to_check=CHECK_WMICAT;

				else
					return ERROR;
				break;
			case 'l': /* value list */
				value_list = optarg;
				break;
			case 'w': /* warning threshold */
				warning_value_string = optarg;
				warning_value=strtoul(optarg,NULL,10);
				check_warning_value=TRUE;
				break;
			case 'c': /* critical threshold */
				critical_value_string = optarg;
				critical_value=strtoul(optarg,NULL,10);
				check_critical_value=TRUE;
				break;
			case 'd': /* Display select for services; Cooser for smallest in WMICOUNTER*/
				if (!strcmp(optarg,"SHOWALL"))
					show_all = TRUE;
				break;
			case 't': /* timeout */
				socket_timeout=atoi(optarg);
				if(socket_timeout<=0)
					return ERROR;
			}
	}


	if (vars_to_check==CHECK_NONE)
		return ERROR;

	if (req_password == NULL)
		req_password = strdup (_("None"));

	return OK;
}



void fetch_data (const char *address, int port, const char *sendb) {
	int result;
   /*	 process_tcp_request2 may be used instead but not compatible with ns_client*/
	result=process_tcp_request(address, port, sendb, recv_buffer,sizeof(recv_buffer));

	if(result!=STATE_OK)
		die (result, _("could not fetch information from server\n"));
		
	if (!strncmp(recv_buffer,"ERROR",5))
		die (STATE_UNKNOWN, "Client - %s\n",recv_buffer);/*changed from NSClient to be inclsive of NC_Net*/
}



int strtoularray(unsigned long *array, char *string, const char *delim) {
	/* split a <delim> delimited string into a long array */
	int idx=0;
	char *t1;

	for (idx=0;idx<MAX_VALUE_LIST;idx++)
		array[idx]=0;
	
	idx=0;
	for(t1 = strtok(string,delim);t1 != NULL; t1 = strtok(NULL, delim)) {
		if (is_numeric(t1) && idx<MAX_VALUE_LIST) {
			array[idx]=strtoul(t1,NULL,10);
			idx++;
		} else  
			return FALSE;
	}		
	return TRUE;
}

void preparelist(char *string) {
	/* Replace all , with & which is the delimiter for the request */
	int i;

	for (i = 0; (size_t)i < strlen(string); i++)
		if (string[i] == ',') {
			string[i]='&';
		}
}

void preparelist2(char *string, char c) {
	/* Replace all delimiter c  with & which is the delimiter for the request */
	int i;

	for (i = 0; (size_t)i < strlen(string); i++)
		if (string[i] == c) {
			string[i]='&';
		}
}


void print_help(void)
{
	print_revision(progname,revision);
	
	printf ("Copyright (c) 2000 Yves Rubin (rubiyz@yahoo.com)\n");
	printf (COPYRIGHT, copyright, email);
	
	printf (_("This plugin collects data from the NSClient or NC_Net service running on a\n\
Windows NT/2000/XP/2003 server.\n\n"));

	print_usage();
	
  printf (_("\nOptions:\n\
-H, --hostname=HOST\n\
  Name of the host to check\n\
-p, --port=INTEGER\n\
  Optional port number (default: %d)\n\
-s <password>\n\
  Password needed for the request\n\
-w, --warning=INTEGER\n\
  Threshold which will result in a warning status\n\
-c, --critical=INTEGER\n\
  Threshold which will result in a critical status\n\
-t, --timeout=INTEGER\n\
  Seconds before connection attempt times out (default: %d)\n\
-h, --help=STRING\n\
  Print this help screen\n\
-V, --version\n\
  Print version information\n"), PORT, 20);
	
  printf (_("\
-v, --variable=STRING\n\
  Variable to check.  Valid variables are:\n\
  Use --help=<check_variable_name> -- to list help for that command.\n"));

  printf (_("\
   CLIENTVERSION = Get the Check_nt version Number\n\
   CPULOAD = Average CPU load on last x minutes.\n\
   UPTIME = Get the uptime of the machine.\n\
   USEDDISKSPACE = check Size(in Megs) or percentage of disk use.\n\
   FREEDISKSPACE = check Size(in Megs) or percentage of disk free.\n\
   MEMUSE = Memory use.\n\
   SERVICESTATE = Check the state of one or several services.\n\
   PROCSTATE = Check if one or several process are running.\n\
   COUNTER = Check any performance counter of Windows NT/2000.\n\
   FILEAGE = Checks how old a file is .\n\
   INSTANCES = Check any performance counter Category for availible instances.\n\
   EVENTLOG = Check any Event Log in Windows for any entry.\n\
   WMICHECK = performs a WMI query on Windows server.\n\
   WMICOUNTER = Checks -w -c against a specific querry\n\
   WMICAT = Runs WMI Query and outputs Concatinated results\n\
   CONFIG = push a configuration variable change to NC_Net via active checks.\n\
   ENUMCONFIG = Prints NC_Net's configuration.\n\
   ENUMPASSIVE = Print out list of service descriptions from passive.cfg\n\
   DELPASSIVE = Deletes a passive check from NC_Net passive.cfg.\n\
   ENUMCOUNTER = Enumerates performance counters.\n\
   ENUMCOUNTERDESC = Prints the internal detailed description of a performance counter.\n\
   ENUMSERVICE = Print out list of all services\n\
   ENUMPROCESS = Prints all running processes.\n\n\
   ADDPASSIVE = Add a passive check to passive.cfg.\n\
     DO NOT use -v ADDPASSIVE  \n\
	 Instead run the desired passive check as an active check from the command line.\n\
	 then after you tested the command add the switch -S <service description>  \n\
	 (NOTE this is a capital S) \n"));
  printf (_("\
-S --addpassive=STRING\n\
  the STRING should be the Nagios service description. (unique for each host)\n\
   This option is used primarily to add a passive check to NC_Net's passive.cfg.\n\
   Active checks do not require the service description. \n\
   When this option is added to a service check it will send the check as an addition \n\
   to the passive.cfg.  This test will verify the check will return an OK result. \n\
   If the check does not return OK the check will not be added or modified to passive.cfg\n"));

  printf (_("Notes:\n\
 - NC_Net should be running.  \n\
   (http://www.shatterit.com/NC_Net).\n"));
 }



void print_usage(void)
{
	printf("\
      Usage: %s -H host -v variable [-p port] [-w warning] [-c critical] \n\
                [-l params] [-d SHOWALL] [-t timeout] [-S Service_description]\n", progname);
}

void print_command_CLIENTVERSION(void){
  printf (_("\
   CLIENTVERSION = Get the NSClient version\n\
     If -l <version> is specified, will return warning if versions differ.\n"));
}
void print_command_CPULOAD(void){
  printf (_("\
   CPULOAD = Average CPU load on last x minutes.\n\
     Request a -l parameter with the following syntax:\n\
     -l <minutes range>,<warning threshold>,<critical threshold>.\n\
     <minute range> should be less than 24*60.\n\
     Thresholds are percentage and up to 10 requests can be done in one shot.\n\
     ie: -l 60,90,95,120,90,95\n"));
}
void print_command_UPTIME(void){ printf (_("\
   UPTIME = Get the uptime of the machine.\n\
     No specific parameters. No warning or critical threshold\n"));
 }
void print_command_USEDDISKSPACE(void){ printf (_("\
   USEDDISKSPACE = Size and percentage of disk use.\n\
     Request a -l parameter containing the drive letter only.\n\
     Thresholds can be specified (in precentage used) with -w and -c.\n\
	 When the warning or critical value is less than 100 it is evaluated as a percentage of space.\n\
	 When the warning or critical value are above 100 they are evaluated as MegaBytes.\n"));	 
 }
void print_command_FREEDISKSPACE(void){ printf (_("\
   FREEDISKSPACE = Size and percentage of disk use.\n\
     Request a -l parameter containing the drive letter only.\n\
     Thresholds can be specified (in megabytes free) with -w and -c.\n\
	 When the warning or critical value is less than 100 it is evaluated as a percentage of space.\n\
	 When the warning or critical value are above 100 they are evaluated as bytes.\n\
	 Warning and critical are Integers and therfore limited to numbers less than 4 gigs.\n"));

 }
void print_command_MEMUSE(void){ printf (_("\
   MEMUSE = Memory use.\n\
     Warning and critical thresholds can be specified with -w and -c.\n"));
 }
void print_command_SERVICESTATE(void){ printf (_("\
   SERVICESTATE = Check the state of one or several services.\n\
     Request a -l parameters with the following syntax:\n\
     -l <service1>,<service2>,<service3>,...\n\
     You can specify -d SHOWALL in case you want to see working services\n\
     in the returned string.\n"));
  }
void print_command_PROCSTATE(void){ printf (_("\
   PROCSTATE = Check if one or several process are running.\n\
     Same syntax as SERVICESTATE.\n"));
  }
void print_command_COUNTER(void){ printf (_("\
   COUNTER = Check any performance counter of Windows NT/2000.\n\
     This check accepts -w and -c\n\
     Request a -l parameters with the following syntax:\n\
	 -l \"\\\\<performance object>\\\\counter\"[,\"<Label>\"][,<UOM>][,<MIN>][,<MAX>]\n\
	 from the command line single \\ works.\n\
	 COUNTER NOW OVERLOADED To also use the following format\n\
	 -l \"^COUNTERCATEGORY^INSTANCE^CounterNAME\"[,\"<Label>\"][,<UOM>][,<MIN>][,<MAX>]\n\
	 -l \"^COUNTERCATEGORY^CounterNAME\"[,\"<Label>\"][,<UOM>][,<MIN>][,<MAX>]\n\
	 Must have performance category and instance encapsulated in \\\n\
      the first parameter is the counter that is sent to NC_Net.\n\
	  the rest of the parameters are for performance data only.\n\
	  older version of NC_Net used the label for formating\n\
	  the counter should be in the format of:\n\
	  \"\\category(Instance)\\counter\"\n\
	  please keep this in Quotes for consistancy \n\
	  category is the performance counter category \n\
	  Instance is in parenthases if no instance for the category then leave out.\n\
	  Do not use empty parenthases.\n\
	  the counter is the performance counter's countner.\n\
	  Automatic detection of %% is done only against the performance counter\n\
	    it is no longer done against the entier -l option.\n\
	  label is the label for performance data\n\
	  If the label is omited then the performance counter object will be used.\n\
	  UOM - Unit of Measurment -if no UOM use a zero 0, \n\
	  a zero tells check_nt to ignore the UOM in the output.\n\
	  examples of UOM- s,us,ms,%%,B,KB,MB,TB,c \n\
      c- is for continous counter. \n\
	  Min and Max are optional but are used by third party program (RRD) for graphing.\n\
	 Some examples:\n\
	-l \"\\Process(_Total)\\Thread Count\",\"Thread Count\",MB,0,1000 -w 5 -c 700\n\
	Thread Count = 534.00 MB | 'Thread Count'=534.000000MB;5.000000;700.000000;0.000000;1000.000000\n\
        -l \"\\Paging File(_Total)\\%% Usage\"\n\
	\\Paging File(_Total)\\%% Usage = 36.61 %%\n\
        -l \"\\paging file(_total)\\%% usage\"\n\
	\\paging File(_total)\\%% usage = 36.61 %%\n\
        -l \"\\paging file(_total)\\%% usage\",\"test1\"\n\
	test1 = 36.60 % | test1=36.599730%;;;0.000000;100.000000\n\
        -l \"\\paging file(_total)\\%% usage\",\"test1\",%%,20\n\
	test1 = 36.60 % | test1=36.599730%;;;20.000000;100.000000\n\
	-l \"\\Server\\Server Sessions\",\"test SS\",%%\n\
	test SS = 1.00 %% | 'test SS'=1.000000%%;;;\n\
	-l  \"\\Server\\Server Sessions\",\"Server Sessions\",0,0,50 -w 20 -c 45\n\
	Server Sessions = 1.00 c | 'Server Sessions'=1.000000;20.000000;45.000000;0.000000;50.000000\n"));

 }
void print_command_FILEAGE(void){ printf (_("\
   FILEAGE = Checks how old a file is .\n\
     Request a -l parameters with the following syntax:\n\
     -l \"<File path>\\\\<File Name>\"\n\
     Warning and critical thresholds can be specified with -w and -c.\n")); 
 }
void print_command_INSTANCES(void){ printf (_("\
   INSTANCES = Check any performance counter Category for availible instances.\n\
     Request a -l parameters with the following syntax:\n\
     -l <Perfomance Counter Category>,<Perfomance Counter Category>,...\n\
     Does not use -w or -c,\n\
     returns a list of Instances for each Category in the list of categories.\n\
     example:\n\
     -l \"Memory,Process,Print Queue\"\n"));
  }
void print_command_EVENTLOG(void){printf (_("\
   EVENTLOG = Check any Event Log in Windows for any entry.\n\
     Request a -l parameters with the following syntax:\n\
     -l \"<Event Log>,<Event Type>,<minutes range>,\n\
         <Source Filter list>,<Message Filter List>,<Event ID Filter List>\"\n\
     <Event Log> - any, System, Application, Security \n\
         or any other non-standard Event Log. 'any' will check all logs.\n\
     <Event Type> - any, Information, Warning, Error,\n\
         or other non-standard Event Type. 'any' will check all Types.\n\
     <minutes range> - Maximum age in minutes of event entries to check.\n\
         Use 0 to check all event Entries in log.\n\
     <Source Filter List> Use 0 to diable the Source Filter.\n\
         Otherwise enter a comma seperated list \n\
         with the first element being the number of items in the list.\n\
         Use a negitive number to Exclude matching entries.\n\
         Use a positive number to Include only matching entries.\n\
     <Message Filter List> Use 0 to diable the Message Filter.\n\
         (Message Filter accepts Regular Expressions) \n\
         Otherwise enter a comma seperated list \n\
         with the first element being the number of items in the list.\n\
         Use a negitive number to Exclude matching entries.\n\
         Use a Positive number to Include only matching entries.\n\
     <Event ID Filter List> Use 0 to diable the Event ID Filter.\n\
         Otherwise enter a comma seperated list with the first element\n\
         being the number of items in the list.\n\
         Use a negitive sign to Exclude matching entries.\n\
         Use a positive number to Include only matching entries.\n\
     Examples:\n\
         The Following examples will list all events in the System Event Log\n\
         that have a source of eventlog and have the word start or stop\n\
         withing the event message.\n\
         -l \"System,any,0,1,eventlog,2,start,stop,0\"\n\
         -l \"System,any,0,1,eventlog,1,(start|stop),0\"\n"));
 }
void print_command_WMICAT(void) { printf (_("\
   WMICAT = Performs a WMI query on a Windows server\n\
     and returns a concatinated result of the querry as output.\n\
	 This check always returns OK if the query is valid.\n\
	 This check return Warning or Critical if the query fails.\n\
	 This check uses the -l in the same format as WMICHECK.\n\
	 for more details of the -l syntex run --help=WMICHECK\n"));
}
void print_command_WMICHECK(void){ printf (_("\
   WMICHECK = performs a WMI query on Windows server.\n\
   NOTE: the -l parameter must be within quotes \" \n\
     WMI needs to be installed on pre 2000, and Win 9x \n\
	 this command should be run from commandline only \n\
	 Buffer may run out of space before full output is printed\n\
	 USE WMICOUNTER for active check of WMI value (\n\
     Request a -l parameters with the following syntax:\n\
	      -l \"<Namespace>[ [^<Select>|^<FULL SELECT>][^<CLass>][^<condition>] ]\"\n\
     basicly this command does a query to WMI. \n\
     the syntex is fairly loose and the return string typicly has linefeeds in it.\n\
     basic command is -l \"Namespace^Full select statment\" \n\
     the select stament can also be tokenized into seperate parameters as displayed in these examples:\n\
     Example inputs- \n\
     * - list all namespaces \n\
     namespace^* - list all classes in namespace \n\
     namespace^ full querry statment - enter a full querry statment as second parameter\n\
     namespace^*^class - list all instances in class \n\
     namespace^select^class - list specific selected data from all class instances \n\
     \n\
     -l command structure overview\n\
     namespace^select^class^where - \n\
     examples: \n\
     * \n\
     cimv2^* \n\
     cimv2^SELECT Size,Name From win32_logicaldisk where name = 'c:' \n\
     cimv2^size,name^win32_logicaldisk \n\
     cimv2^size,name^win32_logicaldisk^name= 'c:' \n\
     Note: win32_logicaldisk access the floppy drives durring processing.\n"));
  }
void print_command_CONFIG(void){ printf (_("\
	CONFIG = push a configuration variable change to NC_Net via active checks.\n\
	this command should be run from commandline only\n\
	Request a -l parameters with the following syntax:\n\
	-l \"<NC_Net variable>,<Value> \"\n\
	Changes a configuration value to the current running config of NC_Net\
	This can be used to modify all vairibles that are assesable via startup.cfg\
	Use this option with care because it may induce problems (not all dynamic changes have been configured yet\
	To make NC_Net regect this command set lock_active_config to true\
	"));
 }
void print_command_ENUMCONFIG(void){ printf (_("\
   ENUMCONFIG = Prints NC_Net's configuration.\n\
     No specific parameters. No warning or critical threshold\n\
     this command should be run from commandline only\n"));
 }
void print_command_ENUMPASSIVE(void){ printf (_("\
   ENUMPASSIVE = Print out list of service descriptions from passive.cfg\n\
     this command should be run from commandline only\n\
     No specific parameters. No warning or critical threshold.\n"));
  }
void print_command_DELPASSIVE(void){ printf (_("\
   DELPASSIVE = Deletes a passive check from NC_Net passive.cfg.\n\
     this command should be run from commandline only\n\
     Request a -l parameters with the following syntax:\n\
     -l <Service description>\n"));
 }
void print_command_ENUMCOUNTER(void){ printf (_("\
   ENUMCOUNTER = Enumerates performance counters.\n\
     No warning or critical threshold\n\
	 this command should be run from commandline only\n\
	 if -l is ommited the return list will be of perfomance counter Categories. Otherwise\n\
	 -l <performance counter Category>[,<performance counter Category>]\n\
    returns a list of  counters for the specified categories.\n"));
 }   
void print_command_ENUMCOUNTERDESC(void){ printf (_("\
   ENUMCOUNTERDESC = Prints a performance counter's internal detailed description.\n\
     No warning or critical threshold\n\
	 this command should be run from commandline only\n\
	 -l <performance counter Category>[,<performance counter>]\n\
	 -l is comma seperated.  If Counter is ommited it will print the description of the Category.\n"));
 }
void print_command_ENUMSERVICE(void){  printf (_("\
   ENUMSERVICE = Print out list of all services\n\
     No warning or critical threshold.\n\
	 this command should be run from commandline only\n\
     Request a -l parameters with the following syntax:\n\
     -l <type>,[short]\n\
     <type> is the type of Services to enumerate:\n\
     all		- enumerate all found services\n\
     short	- list short names only (default will print descriptive names)\n\
     running	- list all runnning services\n\
     stopped	- list all NOT running services\n\
     automatic- list all services setup for automatic startup type\n\
     manual	- list all services setup for manual startup type\n\
     disabled - list all services that are disabled.\n"));
 } 
void print_command_ENUMPROCESS(void){ printf (_("\
   ENUMPROCESS = Prints all running processes.\n\
     No specific parameters. No warning or critical threshold\n\
     this command should be run from commandline only\n"));
 } 
void print_command_ADDPASSIVE(void){  printf (_("\
   ADDPASSIVE = Add a passive check to passive.cfg.\n\
     DO NOT use -v ADDPASSIVE \n\
	 Instead run the desired passive check as an active check from the command line.\n\
	 then after you tested the command add the switch -S <service description>  \n\
	 (NOTE this is a capital S) \n"));
  printf (_("\
-S --addpassive=STRING\n\
  the STRING should be the Nagios service description. (unique for each host)\n\
   This option is used primarily to add a passive check to NC_Net's passive.cfg.\n\
   Active checks do not require the service description. \n\
   When this option is added to a service check it will send the check as an addition \n\
   to the passive.cfg.  This test will verify the check will return an OK result. \n\
   If the check does not return OK the check will not be added or modified to passive.cfg\n"));
}
void print_command_WMICOUNTER(void){ printf (_("\
   WMICOUNTER = Checks -w or -c against a WMI query result.\n\
     This requires the -d showall to check for max value ( critical if result greater than -c-w)\n\
	 The -d SHOWFAIL will check against a min value (critical if result less than -c -w )\n\
     Then the results will be compared to the warning and critical values.\n\
     WMI has a lot of System data stored within it.\n\
     For more information of using WMI see the WMI Development Kit (Free) available from Microsoft.\n\
	 This check uses the same structure as the WMICHECK. \n\
	 Before using this WMICounter validate that the query work correctly using WMICHECK. \n\
	 It is preferred that each query resolves only to a single object instance being returned.\n\
	 However if more than one object is found the largest value will be returned \n\
	 and compared to the warning and critical values. \n\
	 (using WMICOUNTER against multiple objects can be handy \n\
	 for comparing if any surpass the trigger values.) \n\
	-d showfail is used internally in check_nt and NC_Net for this service check.\n\
	It is used to indicate that the smallest value should be returned instead of the largest.\n\
	You can explicity declare that the check will return an alert when less than the -c or -w \n\
	By using -d SHOWFAIL\n\
	Care should be used when returning the smallest in case the query has some zeros values being returned.\n\
	All values will be converted to doubles during processing, \n\
	this is to simplify the fact that the result can be of any type (double, integer, long, percent) \n"));
 } 

void print_command( char * optarg) {
	/* this function calls specific help topics based on -h <arg> */
	if(strlen(optarg)<4)
        return;
	if(!strcmp(optarg,"CLIENTVERSION"))
        print_command_CLIENTVERSION();
	else if(!strcmp(optarg,"CPULOAD"))
		print_command_CPULOAD();
	else if(!strcmp(optarg,"UPTIME"))
		print_command_UPTIME();
	else if(!strcmp(optarg,"USEDDISKSPACE"))
		print_command_USEDDISKSPACE();
	else if(!strcmp(optarg,"SERVICESTATE"))
		print_command_SERVICESTATE();
	else if(!strcmp(optarg,"PROCSTATE"))
		print_command_PROCSTATE();
	else if(!strcmp(optarg,"MEMUSE"))
		print_command_MEMUSE();
	else if(!strcmp(optarg,"COUNTER"))
		print_command_COUNTER();
	else if(!strcmp(optarg,"FILEAGE"))
		print_command_FILEAGE();
	else if(!strcmp(optarg,"INSTANCES"))
		print_command_INSTANCES();
	else if(!strcmp(optarg,"EVENTLOG"))
		print_command_EVENTLOG();
	else if(!strcmp(optarg,"WMICHECK"))
		print_command_WMICHECK();
	else if(!strcmp(optarg,"FREEDISKSPACE"))
		print_command_FREEDISKSPACE();
	else if(!strcmp(optarg,"CONFIG"))
		print_command_CONFIG();
	else if(!strcmp(optarg,"ENUMCONFIG"))  
		print_command_ENUMCONFIG();
	else if(!strcmp(optarg,"ENUMPASSIVE"))  
		print_command_ENUMPASSIVE();
	else if(!strcmp(optarg,"DELPASSIVE"))  
		print_command_DELPASSIVE();
	else if(!strcmp(optarg,"ENUMPROCESS"))  
		print_command_ENUMPROCESS();
	else if(!strcmp(optarg,"ENUMSERVICE"))  
		print_command_ENUMSERVICE();
	else if(!strcmp(optarg,"WMICOUNTER"))  
		print_command_WMICOUNTER();
	else if(!strcmp(optarg,"ENUMCOUNTER"))  
		print_command_ENUMCOUNTER();
	else if(!strcmp(optarg,"ADDPASSIVE"))  
		print_command_ADDPASSIVE();
	else if(!strcmp(optarg,"ENUMCOUNTERDESC"))  
		print_command_ENUMCOUNTERDESC();
	else if(!strcmp(optarg,"WMICAT"))  
		print_command_WMICAT();

	else
		return;
}

