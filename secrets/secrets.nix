let
   macbookPro =  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILoCNAHItQffIsnsZ68U+6OpvBb4tl2+aLUSea61t46u";
in
{
  "test.age".publicKeys = [ macbookPro ];
}
