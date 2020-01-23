if (($ftype eq "UserDoc") or($ftype eq "lib") or($ftype eq "res") or($ftype eq "modem") or($ftype eq "patch") or($ftype eq "tmpl_cnf") or($ftype eq "tools") or($ftype eq "tarantella") or($ftype eq "actuate") or($ftype eq "dict") or($ftype eq "xml") or($ftype eq "Jar") or($ftype eq "ear") or($ftype eq "war") or($ftype eq "japp") or($ftype eq "jlib") or($ftype eq "j3pty") or($ftype eq "jscript") or($ftype eq "styles") or($ftype eq "j2ee_tmpl")) {
  {
  $genPatchIfNotDev = 1;
  if ($eaccept eq "Delete") {
    printWinFile($out1_text, $sout, 'end', "Removing from Solaris machine\n\n\n", 'title1');
    $out1_text - > see('end');
    $out1_text - > update;
    unlink("${dirSolsybrel}/$staged_filei");
    unlink("${dirSolsybdev}/$staged_filei");
    my $devlibsrc = $fname;
    my $rellibsrc = $fname;
    if ($ftype eq "lib") {
      $devlibsrc = ~s / \.so\.\d + //;
        $rellibsrc = ~s / \.so\. / \. / ;
      `rm -Rf "${dirSolsybrel}/src/$rellibsrc"`;
      `rm -Rf "${dirSolsybdev}/src/$devlibsrc"`
    }

    if (-e "${dirSolsybrel}/$staged_filei" || -e "${dirSolsybdev}/$staged_filei" ||
      ($ftype eq "lib" && (-d "${dirSolsybrel}/src/$rellibsrc" || -d "${dirSolsybdev}/src/$devlibsrc"))) {
      submit_error($ProcAcceptWindow, "Remove Error", $font_comment, "Failed to delete file: ${dirSolsybrel}/$staged_filei");
      printWinFile($out1_text, $sout, 'end', "\nFailed to delete file: ${dirSolsybrel}/$staged_filei\n\n");
      $out1_text - > see('end');
      $out1_text - > update();
      my $end_time = getDateTime();
      foreach $accept_number(@all_accept_number) {
        updateToLog($ldbh, $accept_number, $start_time, $end_time, "staged", "0", "Fail to delete file: ${dirSolsybrel}/$staged_filei at Solaris");
      }
      $iaccept_pnum = 0;
      return $iaccept_pnum;
    } else {
      printWinFile($out1_text, $sout, 'end', "File ${dirSolsybrel}/$staged_filei had been deleted! \n\n");
      $out1_text - > see('end');
      $out1_text - > update;
    }

    if (($MAJ_VER eq $poss_majorv[0] or $MAJ_VER eq "1312"
        or $MAJ_VER eq "1313"
        or $MAJ_VER eq "1314"
        or $MAJ_VER eq "1315"
        or $MAJ_VER eq "1316"
        or $MAJ_VER eq "1317"
        or $MAJ_VER eq "1318"
        or $MAJ_VER eq "1319") && (($ftype eq "lib") or($ftype eq "res"))) {

      printWinFile($out1_text, $sout, 'end', "Removing from Linux machine\n\n\n", 'title1');
      $out1_text - > see('end');
      $out1_text - > update;
      unlink("${dirLinsybrel}/$staged_filei");
      unlink("${dirLinsybdev}/$staged_filei");

      if (-e "${dirLinsybrel}/$staged_filei" || -e "${dirLinsybdev}/$staged_filei") {
        submit_error($ProcAcceptWindow, "Remove Error", $font_comment, "Failed to delete file: ${dirLinsybrel}/$staged_filei");
        printWinFile($out1_text, $sout, 'end', "\nFailed to delete file: ${dirLinsybrel}/$staged_filei\n\n");
        $out1_text - > see('end');
        $out1_text - > update();
        my $end_time = getDateTime();
        foreach $accept_number(@all_accept_number) {
          updateToLog($ldbh, $accept_number, $start_time, $end_time, "staged", "0", "Fail to delete file: ${dirLinsybrel}/$staged_filei at Linux");
        }
        $iaccept_pnum = 0;
        return $iaccept_pnum;
      } else {
        printWinFile($out1_text, $sout, 'end', "File ${dirLinsybrel}/$staged_filei had been deleted! \n\n");
        $out1_text - > see('end');
        $out1_text - > update;
      }
    }
    next;
  }
  # it it 's a lib, bin or res then#
  #do copying at SunOS, HP, Sun Solaris machine

  #
  #print "Copying to three different machines..\n";

  my $tfileDir = `/usr/bin/dirname $staged_filei`;
  chomp($tfileDir);
  my $chkDir = checkDirsBeforeCopying("$dirSolsybrel", "$tfileDir");
  if ($chkDir == 0) {
    local(@mailMatter) = ("Couldn't create $tfileDir under $dirSolsybrel");
    emailByGroup("Directory creation", * mailMatter, * hemedu);
  }
  $slfile = $staged_filei;
  $ldirSolsybqa = $dirSolsybqa;
  $ldirSolsybrel = $dirSolsybrel;
  printWinFile($out1_text, $sout, 'end', "\n\nSolaris...\n");
  my $isl = copyToSL($submit_sunos, $VCS3, * ldirSolsybqa, * ldirSolsybrel, * slfile, * newfile2);
  my $islnl = sprintf("%s", $isl);
  printWinFile($out1_text, $sout, 'end', "$islnl\n");
  $out1_text - > see('end');
  $out1_text - > update;
  if ($isl!~/Success/) {
    submit_error($ProcAcceptWindow, "Copy Error", $font_comment, "Failed to copy to: ${newfile2} at Solaris");
    my $end_time = getDateTime();
    foreach $accept_number(@all_accept_number) {
      updateToLog($ldbh, $accept_number, $start_time, $end_time, "staged", "0", "Fail to copy to: $newfile2 at Solaris.");
    }
    $iaccept_pnum = 0;
    return $iaccept_pnum;
  }
  if (($MAJ_VER eq $poss_majorv[0] or $MAJ_VER eq "1312"
      or $MAJ_VER eq "1313"
      or $MAJ_VER eq "1314"
      or $MAJ_VER eq "1315"
      or $MAJ_VER eq "1316"
      or $MAJ_VER eq "1317"
      or $MAJ_VER eq "1318"
      or $MAJ_VER eq "1319") && (($ftype eq "lib") or($ftype eq "res")) and($solaris_only_acc eq "0")) {

    $slfile = $staged_filei;
    $ldirLinsybqa = $dirLinsybqa;
    $ldirLinsybrel = $dirLinsybrel;
    printWinFile($out1_text, $sout, 'end', "\n\nLinux...\n");
    my $isl_lin = copyToSL($submit_sunos, $VCS3, * ldirLinsybqa, * ldirLinsybrel, * slfile, * newfile2);
    my $islnl_lin = sprintf("%s", $isl_lin);
    printWinFile($out1_text, $sout, 'end', "$islnl_lin\n");
    $out1_text - > see('end');
    $out1_text - > update;
    if ($isl!~/Success/) {
      submit_error($ProcAcceptWindow, "Copy Error", $font_comment, "Failed to copy to: ${newfile2} at Linux");
      my $end_time = getDateTime();
      foreach $accept_number(@all_accept_number) {
        updateToLog($ldbh, $accept_number, $start_time, $end_time, "staged", "0", "Fail to copy to: $newfile2 at Linux.");
      }
      $iaccept_pnum = 0;
      return $iaccept_pnum;
    }
  }
  if ( & isCF()) {
    my $nonCFDevDir = $dirSolsybdev;
    $nonCFDevDir = ~s / \d$ //i;
    $ldirSolsybdev = $nonCFDevDir;
    $isl = copyToSL($submit_sunos, $VCS3, * ldirSolsybrel, * ldirSolsybdev, * slfile, * newfile2);
    $islnl = sprintf("%s", $isl);
    printWinFile($out1_text, $sout, 'end', "$islnl\n");
    $out1_text - > see('end');
    $out1_text - > update;
    if ($isl!~/Success/) {
      submit_error($ProcAcceptWindow, "Copy Error", $font_comment, "Failed to copy to: ${newfile2} at Solaris");
      my $end_time = getDateTime();
      foreach $accept_number(@all_accept_number) {
        updateToLog($ldbh, $accept_number, $start_time, $end_time, "staged", "0", "Fail to copy to: $newfile2 at Solaris.");
      }#
      remove the lock
      $istage_pnum = 0;
      return $istage_pnum;
    }
  }
  next;
}