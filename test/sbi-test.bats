BASE_DIR=/tmp/sbi-test
DATA_DIR=$BASE_DIR/data
SNAPSHOT_DIR=$BASE_DIR/snapshot
BACKUP_DIR=$BASE_DIR/backup

TEST_DATA_TAR=~/slag-tools/test-resources/sbi-test.tar.gz
A_TEST_FILE=/tmp/sbi-test/data/joe/test.dat

setup() {
  run mkdir $BASE_DIR
  [ "$status" = 0 ]  

  run mkdir $DATA_DIR
  [ "$status" = 0 ] 

  run mkdir $SNAPSHOT_DIR
  [ "$status" = 0 ] 

  run mkdir $BACKUP_DIR
  [ "$status" = 0 ] 

  cd $DATA_DIR
  
  run tar -xf $TEST_DATA_TAR
  [ "$status" = 0 ] 

  cd ~

  if [ ! -f $A_TEST_FILE ] ; then
    echo "coping test data seems to be failed: $A_TEST_FILE"
    return 1
  fi
}

@test "sbi-test" {
  ~/slag-tools/bash/bkp-create-snapshot.sh -s=joe -p=$DATA_DIR -t=$SNAPSHOT_DIR
  ~/slag-tools/bash/bkp-cleanup-traverse-not-to-backup.sh -d=$SNAPSHOT_DIR
  ~/slag-tools/bash/bkp-create-backup.sh -s=joe -p=$SNAPSHOT_DIR -t=$BACKUP_DIR

  # Up to here the tests are running correct. You can check this manually.
  # But on this point it should be some asserts to verify automaticly that all processes are ok.


  # collect data for assertions
  cd $BASE_DIR

  find ./snapshot -type f | wc -l > file-count-snapshot.txt
  stat --printf="%s" backup/joe*.tar.gz > file-size-backup-tar.txt

  # assert collected data

  # assert file count for snapshot dir
  local expected_file_count=5

  run cat file-count-snapshot.txt
  [[ "$output" = $expected_file_count ]]

  # assert file size of backup tar
  local min_tar_file_size=4050
  local max_tar_file_size=4080

  run cat file-size-backup-tar.txt

  [[ "$output" -ge $min_tar_file_size ]]
  [[ "$output" -le $max_tar_file_size ]]

  cd ~ 
}

teardown() {
  local ts=$(date +%s)
  mv $BASE_DIR $BASE_DIR-$ts
}
