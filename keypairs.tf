resource "aws_key_pair" "cvengine" {

  key_name   = "cvengine"
  public_key = file(var.Public_key_path)

}