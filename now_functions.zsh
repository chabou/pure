# Inspired by https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/jsontools/jsontools.plugin.zsh
now_current_team() {
  NOW_CONFIG_FILE=~/.now.json

  if [[ ! -r  $NOW_CONFIG_FILE ]]; then
    exit
  fi

  now_config=`cat $NOW_CONFIG_FILE`

  if [[ $(whence $JSONTOOLS_METHOD) = "" ]]; then
    JSONTOOLS_METHOD=""
  fi

  if [[ $(whence node) != "" && ( "x$JSONTOOLS_METHOD" = "x"  || "x$JSONTOOLS_METHOD" = "xnode" ) ]]; then
    cat $NOW_CONFIG_FILE | xargs -0 node -e "try {data = JSON.parse(process.argv[1]); console.log((data.currentTeam && data.currentTeam.name) || data.user.username)} catch (e) {}"
  elif [[ $(whence python) != "" && ( "x$JSONTOOLS_METHOD" = "x" || "x$JSONTOOLS_METHOD" = "xpython" ) ]]; then
    cat $NOW_CONFIG_FILE | python -c "
  import json, sys;
  try:
    data = json.loads(sys.stdin.read())
    if 'currentTeam' not in data:
      print(data['user']['username'])
    else:
      print(data['currentTeam']['name'])
  except type as err:
    print('except', err)
    pass
  sys.exit(0)"
  elif [[ $(whence ruby) != "" && ( "x$JSONTOOLS_METHOD" = "x" || "x$JSONTOOLS_METHOD" = "xruby" ) ]]; then
    cat $NOW_CONFIG_FILE | ruby -e "require \"json\"; begin; data = JSON.parse(STDIN.read); puts (data['currentTeam'] && data['currentTeam']['name']) || data['user']['username']; rescue Exception => e; end"
  fi

  unset JSONTOOLS_METHOD
}

