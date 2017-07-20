#!/usr/bin/perl
# 
# Copyright Statement:
# --------------------
# This software is protected by Copyright and the information contained
# herein is confidential. The software may not be copied and the information
# contained herein may not be used or disclosed except with the written
# permission of MediaTek Inc. (C) 2014
# 
# BY OPENING THIS FILE, BUYER HEREBY UNEQUIVOCALLY ACKNOWLEDGES AND AGREES
# THAT THE SOFTWARE/FIRMWARE AND ITS DOCUMENTATIONS ("MEDIATEK SOFTWARE")
# RECEIVED FROM MEDIATEK AND/OR ITS REPRESENTATIVES ARE PROVIDED TO BUYER ON
# AN "AS-IS" BASIS ONLY. MEDIATEK EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NONINFRINGEMENT.
# NEITHER DOES MEDIATEK PROVIDE ANY WARRANTY WHATSOEVER WITH RESPECT TO THE
# SOFTWARE OF ANY THIRD PARTY WHICH MAY BE USED BY, INCORPORATED IN, OR
# SUPPLIED WITH THE MEDIATEK SOFTWARE, AND BUYER AGREES TO LOOK ONLY TO SUCH
# THIRD PARTY FOR ANY WARRANTY CLAIM RELATING THERETO. MEDIATEK SHALL ALSO
# NOT BE RESPONSIBLE FOR ANY MEDIATEK SOFTWARE RELEASES MADE TO BUYER'S
# SPECIFICATION OR TO CONFORM TO A PARTICULAR STANDARD OR OPEN FORUM.
# 
# BUYER'S SOLE AND EXCLUSIVE REMEDY AND MEDIATEK'S ENTIRE AND CUMULATIVE
# LIABILITY WITH RESPECT TO THE MEDIATEK SOFTWARE RELEASED HEREUNDER WILL BE,
# AT MEDIATEK'S OPTION, TO REVISE OR REPLACE THE MEDIATEK SOFTWARE AT ISSUE,
# OR REFUND ANY SOFTWARE LICENSE FEES OR SERVICE CHARGE PAID BY BUYER TO
# MEDIATEK FOR SUCH MEDIATEK SOFTWARE AT ISSUE.
# 
# THE TRANSACTION CONTEMPLATED HEREUNDER SHALL BE CONSTRUED IN ACCORDANCE
# WITH THE LAWS OF THE STATE OF CALIFORNIA, USA, EXCLUDING ITS CONFLICT OF
# LAWS PRINCIPLES.  ANY DISPUTES, CONTROVERSIES OR CLAIMS ARISING THEREOF AND
# RELATED THERETO SHALL BE SETTLED BY ARBITRATION IN SAN FRANCISCO, CA, UNDER
# THE RULES OF THE INTERNATIONAL CHAMBER OF COMMERCE (ICC).
# 

my $signSubStr;
@arguments = @ARGV;
$MTK_TARGET_PROJECT = lc($ARGV[0]);

if ($#arguments < 0)
{
  die "Please specify the project name. Usage: device/mediatek/build/build/tools/gen_relkey/gen_relkey.pl <Project>\n";
} 
elsif ($#arguments >= 1)
{
  die "Please only specify the project name. NOT specify any more arguments. Usage: device/mediatek/build/build/tools/gen_relkey/gen_relkey.pl <Project>\n";
}
else
{
  # get signature input
  $signSubStr = inputSignSubject();
  print "\nYour signature subject is '$signSubStr'\n";
}

$result = 0;

# gen. release key/certificate
print "Start to generate release key/certificate for application signing...\n";
print "make MTK_TARGET_PROJECT=$MTK_TARGET_PROJECT SIGNATURE_SUBJECT=$signSubStr -f device/mediatek/build/build/tools/gen_relkey/gen_relkey.mk";
$result = &p_system("make MTK_TARGET_PROJECT=$MTK_TARGET_PROJECT SIGNATURE_SUBJECT=$signSubStr -f device/mediatek/build/build/tools/gen_relkey/gen_relkey.mk 2>/dev/null");
#(exit 255) if ($result >= 255);
exit $result;

sub CurrTimeStr
{
  my($sec, $min, $hour, $mday, $mon, $year) = localtime(time);
  return (sprintf "%4.4d/%2.2d/%2.2d %2.2d:%2.2d:%2.2d", $year+1900, $mon+1, $mday, $hour, $min, $sec);
}

sub p_system
{
  my ($cmd) = @_;
  my ($debugp) = 0;
  my $result;
  ($debugp != 0) && print("$cmd\n");
  ($performanceChk == 1) && print &CurrTimeStr . " system $cmd\n";
  $result = system("$cmd");
  ($performanceChk == 1) && print &CurrTimeStr . " exit $cmd\n";
  return $result;
}

# interactive mode for inputting signature subject
sub inputSignSubject
{
  my $signature =
     {
       '0-C'            => ['C', '', 'Country Name (2 letter code)'],
       '1-ST'           => ['ST', '', 'State or Province Name (full name)'],
       '2-L'            => ['L', '', 'Locality Name (eg, city)'],
       '3-O'            => ['O', '', 'Organization Name (eg, company)'],
       '4-OU'           => ['OU', '', 'Organizational Unit Name (eg, section)'],
       '5-CN'           => ['CN', '', 'Common Name (eg, your name or your server hostname)'],
       '6-emailAddress' => ['emailAddress', '', 'Contact email address']
     };

  my $subjectStr = "";
  print "Please enter the signature subject as follows.\n";

  foreach my $k (sort keys %$signature)
  {
    while (1)
    {
      if (!$signature->{$k}[1])
      {
        # print promote message
        print "$signature->{$k}[2]: ";
        $signature->{$k}[1] = <STDIN>;
        chomp $signature->{$k}[1];
        if ($signature->{$k}[1])
        {
          $subjectStr .= "/$signature->{$k}[0]=$signature->{$k}[1]";
          last;
        }
      }
    }
  }

  return $subjectStr;
}

