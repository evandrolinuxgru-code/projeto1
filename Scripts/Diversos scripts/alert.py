#!/usr/bin/perl
my $hostname = `hostname`;
my $aide =  "/usr/sbin/aide -c /etc/aide.conf";
my $email = "evandro.santiago\@gru.com.br";
my $timestamp = `/bin/date +\%Y-\%m-\%d.\%H-\%M`;
my $output = "";
my $added = -1;
my $removed = -1;
my $changed = -1;
my $warning = 0;
my $found_no_differences = 0;
open(AIDE, "$aide --check|");
while (my $line=<AIDE>) {
    chomp($line);
    $output = $output.$line."\n";
    if ($line =~ /Added entries\:\s*(\w+)/) { $added = $1; }
    if ($line =~ /Removed entries\:\s*(\w+)/) { $removed = $1; }
    if ($line =~ /Changed entries\:\s*(\w+)/) { $changed = $1; }
    if ($line =~ /WARNING\:/) { $warning = $warning + 1; }
    if ($line =~ /AIDE found NO differences/) { $found_no_differences = 1; }
}
close(AIDE);
if ($found_no_differences > 0) { exit(0); }
if ($added > 0 || $removed > 0 || $changed > 0 || $warning > 0 || $added == -1 || $changed == -1) {
        open MAIL, "|echo 'Subject: Alerta $hostname $timestamp\n\n $output' | /usr/sbin/ssmtp -v $email";
    print MAIL $output;
    close MAIL;
    system("$aide --init");
    system("mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz");
}
