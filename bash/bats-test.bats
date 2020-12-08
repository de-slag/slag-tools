@test "bats-test1" {
  run ls > ls.txts
  [ "$status" = 0 ]
}
