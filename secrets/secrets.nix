let
   macbookPro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9gk0E7LLw6c1U0q4bXJ4OpPWtGRcoh8VeS9lIzMY35";
in
{
  "test.age".publicKeys = [ macbookPro ];
}
