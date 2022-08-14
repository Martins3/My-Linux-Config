#!/run/current-system/sw/bin/bash
# @todo 不知道为什么，是不可以使用 #!/usr/bin/env bash，会被报错的
# 肯定是和环境变量有关的
git=/home/martins3/.nix-profile/bin/git

echo "Begin the kernel synchronizing:"
kernel=/home/martins3/core/linux
cd $kernel || exit
# https://stackoverflow.com/questions/6245570/how-do-i-get-the-current-branch-name-in-git
branch=$($git rev-parse --abbrev-ref HEAD)
if [[ $branch != master ]]; then
  echo "checkout to master"
  sleep infinity
fi

cur_commit_id=$($git rev-parse --short HEAD)
$git pull
latest_commit_id=$($git rev-parse --short HEAD)

echo "#!/usr/bin/env bash" >news.sh
echo "tig $cur_commit_id..$latest_commit_id" >>news.sh
chmod +x news.sh

sleep infinity
