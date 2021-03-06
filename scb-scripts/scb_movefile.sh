#!/usr/bin/ksh
########################################################################################
# Program ID      : scb_runsftpnt.sh
#
# Function        : Script to send outgoing file to NT using Secure ftp
#
# Program History :
#
# Date       Amended By           Changes/Remarks
# ========   ================     ===============
# 20061206   Geetha Krishnan      New Program 
########################################################################################


########################################################################################
# Function to display the error and usage
########################################################################################
display_error_usage()
{
PARM=$1
echo "Error: $PARM was not specified"
echo "Usage: `basename $0` FILENAME ODATE"
exit 1
}


########################################################################################
# To check the parameter 
########################################################################################
if [ "$1" = "" ]; then
   display_error_usage FILENAME
fi
FILENAME=$1

if [ "$2" = "" ]; then
   display_error_usage "ORDER DATE"
fi
ODATE=$2


########################################################################################
# To get the other parameters
########################################################################################
#if [ -f $HOME/$PASSWDFILE ]; then
#   FTPNTLINE=`cat $HOME/$PASSWDFILE | grep ^$FILENAME`
#
#   if [ "$FTPNTLINE" = "" ]; then
#      echo "\n\nFILENAME $FILENAME does not exist in $HOME/$PASSWDFILE file"
#      exit 1
#   fi
#else
#   echo "\n\n$HOME/$PASSWDFILE does not exist....."
#   exit 1
#fi

TARGETDIR=/prd/psftp/gbl/psbatch/outgoing
REMOTEHOST=10.20.210.237
USERID=psbatch
CDTRANSFER=/prd/psftp/gbl/psbatch/outgoing
export TARGETDIR REMOTEHOST USERID CDTRANSFER

DATE_FMT=%ddmmyyyy%

echo $FILENAME | grep $DATE_FMT >/dev/null
if [ $? = 0 ]; then
  ODATE_DD=`echo $ODATE | cut -c7-8`
  ODATE_MM=`echo $ODATE | cut -c5-6`
  ODATE_YYYY=`echo $ODATE | cut -c1-4`
  NEW_ODATE=$ODATE_DD$ODATE_MM$ODATE_YYYY
  FILENAME=`echo $FILENAME | sed "s/$DATE_FMT/$NEW_ODATE/g"`
  echo Translated Filename - $FILENAME
fi

########################################################################################
# To execute the ftp 
########################################################################################
#TMPLOG=$PSBATCHLOG/scb_runsftpnt_$FILENAME.log

#TMPFILES=0

# to match filesize greater than zero for HKG and GBR
#MATCHFILESIZE=0

#if   [ -s $CDTRANSFER/$FILENAME ]; then
#   MATCHFILESIZE=1
#fi 

# to Skip FTP transmission if zero byte file present
#TMPFILES=0
#if  [ $MATCHFILESIZE = 0 ]; then
#    TMPFILES=0
#    echo "Zero Bytes $FILENAME FILE"
#   rm -f $CDTRANSFER/$FILENAME
#    # rm -f $TMPLOG
#    exit 0
#fi

# If file size is greater than zero bytes and to create archive directory and copy the file to cdtransfer
#if [ $MATCHFILESIZE = 1 ]; then
#   TMPFILES=1
#   FREQ_DESC="daily"
#   if [ ! -d "$ARCHIVEDIR/$FREQ_DESC" ]; then
#      mkdir $ARCHIVEDIR/$FREQ_DESC
#      chmod 775 $ARCHIVEDIR/$FREQ_DESC
#   fi

#   if [ ! -d "$ARCHIVEDIR/$FREQ_DESC/$ODATE" ]; then
#      mkdir $ARCHIVEDIR/$FREQ_DESC/$ODATE
#      chmod 775 $ARCHIVEDIR/$FREQ_DESC/$ODATE
#   fi
#else
#   TMPFILES=0
#fi

# to Process FTP transmission 
#if [ $TMPFILES -eq 1 ]; then
cd $CDTRANSFER 
#/usr/bin/scp -P 22 $FILENAME  $USERID@$REMOTEHOST:$TARGETDIR/$FILENAME

#mv $FILENAME1 $FILENAME1.Z

mv $FILENAME $NASOUTPATH

if [ $? = 0 ]; then
   echo "\n$FILENAME file was transferred successfully....."
   STATUS=0
   #changes made for archiving the files from  the incoming folders 
else
   echo "\n$FILENAME file transfer failed....."
   STATUS=1
fi

# rm -f $TMPLOG
exit $STATUS
