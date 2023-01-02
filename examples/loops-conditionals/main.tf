terraform {
  required_version = ">= 1.0.11"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.1.0"
    }
  }
}

# define a list of values
variable "numbers" {
  default = ["one", "two", "three"]
  type    = list(any)
}

# loop through all values of list and save them to files
resource "local_file" "count" {
  count    = length(var.numbers)
  filename = "./${var.numbers[count.index]}-count.txt"
  content  = "${var.numbers[count.index]} is a cool number!"
}

# same thing as above but using foreach instead of count
resource "local_file" "for_each" {
  for_each = toset(var.numbers)
  filename = "./${each.value}-foreach.txt"
  content  = "${each.value} is an awesome number!F"
}
