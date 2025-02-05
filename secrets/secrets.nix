let
   macbookPro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILoCNAHItQffIsnsZ68U+6OpvBb4tl2+aLUSea61t46u";
   macStudio = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKH0TN+dcZQIO1L2zN6xZMizPve7MDGlLPnwLEINiIpd";
in
{
  "test.age".publicKeys = [ macbookPro macStudio ];
  "aider.env.age".publicKeys = [macbookPro macStudio];
}
