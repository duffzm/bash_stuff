# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/Zach.Duff/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/Zach.Duff/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/Zach.Duff/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/Zach.Duff/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

## Functions
hello-world () {
    echo "Hello world!";
}

my-option-function() {
  declare -A options
  # Defaults
  PROFILE_OPTION="profile"
  STACK_FILTER_OPTION="stack-filter"
  RESOURCE_FILTER_OPTION="resource-filter"
  options[$PROFILE_OPTION]="wdpr-guest360-dev"
  options[$STACK_FILTER_OPTION]="guest360"
  options[$RESOURCE_FILTER_OPTION]="*"
  options[$RESOURCE_TYPE_OPTION]="AWS::CloudWatch::Alarm"

  while [[ $# -gt 0 ]]
  do
    key="$1"

    case $key in
      --$PROFILE_OPTION)
        options[$PROFILE_OPTION]="$2"
        shift # past argument
        shift # past value
        ;;
      --$STACK_FILTER_OPTION)
        options[$STACK_FILTER_OPTION]="$2"
        shift # past argument
        shift # past value
        ;;
      --$RESOURCE_FILTER_OPTION)
        options[$RESOURCE_FILTER_OPTION]="$2"
        shift # past argument
        shift # past value
        ;;
      --$RESOURCE_TYPE_OPTION)
        options[$RESOURCE_TYPE_OPTION]="$2"
        shift # past argument
        shift # past value
        ;;
      *)    # unknown option
        shift # past argument
        ;;
    esac
  done
  profile=${options[$PROFILE_OPTION]}
  stack_filter=${options[$STACK_FILTER_OPTION]}
  resource_filter=${options[$RESOURCE_FILTER_OPTION]}
  resource_type=${options[$RESOURCE_TYPE_OPTION]}

  echo "Profile: $profile"
  echo "Stack Filter: $stack_filter"
  echo "Resource Type: $resource_type"
  echo "Resource ID Filter: $resource_filter"
}

docker-nuke () {
  docker stop $(docker ps -a -q);
  docker rm $(docker ps -a -q);
  docker rmi $(docker images -a -q);
  docker volume prune --force;
  docker system prune --force;
}

# Remove Cloudformation Stacks
remove-stacks-containing() {
  pattern=".*$1.*"
  if [ "$2" = "--profile" ]; then
        profile=$3
  else
    profile="wdpr-guest360-dev"
  fi
  echo Pattern: $pattern
  echo Profile: $profile
  while true; do
      for R in us-east-1 us-west-2; do
          echo "region: $R"
          stack_summaries=$(aws --region $R cloudformation list-stacks \
            --stack-status-filter CREATE_COMPLETE ROLLBACK_COMPLETE UPDATE_COMPLETE UPDATE_ROLLBACK_COMPLETE DELETE_FAILED \
            --profile $profile)
          stack_names=$(echo -E $stack_summaries | jq -r '.StackSummaries[].StackName')
          filtered_stack_names=$(echo -E $stack_names | grep -i $pattern)
          echo "Stacks to DELETE: $filtered_stack_names"
          echo -E $filtered_stack_names | \
              tee /dev/stderr | \
              xargs -n1 -I% aws --region $R cloudformation delete-stack --stack-name % \
              --profile $profile
      done
      echo '###'
      sleep 20
  done
}

# Remove Cloudformation Stacks
list-stack-resources-by-type() {
  declare -A options
  # Defaults
  PROFILE_OPTION="profile"
  STACK_FILTER_OPTION="stack-filter"
  RESOURCE_FILTER_OPTION="resource-filter"
  RESOURCE_TYPE_OPTION="resource-type"
  options[$PROFILE_OPTION]="wdpr-guest360-dev"
  options[$STACK_FILTER_OPTION]="guest360"
  options[$RESOURCE_FILTER_OPTION]="*"
  options[$RESOURCE_TYPE_OPTION]="AWS::CloudWatch::Alarm"

  while [[ $# -gt 0 ]]
  do
    key="$1"

    case $key in
      --$PROFILE_OPTION)
        options[$PROFILE_OPTION]="$2"
        shift # past argument
        shift # past value
        ;;
      --$STACK_FILTER_OPTION)
        options[$STACK_FILTER_OPTION]="$2"
        shift # past argument
        shift # past value
        ;;
      --$RESOURCE_FILTER_OPTION)
        options[$RESOURCE_FILTER_OPTION]="$2"
        shift # past argument
        shift # past value
        ;;
      --$RESOURCE_TYPE_OPTION)
        options[$RESOURCE_TYPE_OPTION]="$2"
        shift # past argument
        shift # past value
        ;;
      *)    # unknown option
        shift # past argument
        ;;
    esac
  done
  profile=${options[$PROFILE_OPTION]}
  stack_filter=${options[$STACK_FILTER_OPTION]}
  resource_filter=${options[$RESOURCE_FILTER_OPTION]}
  resource_type=${options[$RESOURCE_TYPE_OPTION]}

  echo "Profile: $profile"
  echo "Stack Filter: $stack_filter"
  echo "Resource Type: $resource_type"
  echo "Resource ID Filter: $resource_filter"

  AWS_PROFILE=$profile
  matching_resources=()
  for R in us-east-1; do
      echo "Region: $R"
      stack_summaries=$(aws --region $R cloudformation list-stacks --profile $profile)
      stack_names=$(echo -E $stack_summaries | jq -r '.StackSummaries[].StackName')
      stack_names="${stack_names:l}"  # to lower case
      filtered_stack_names=("${(@f)$(echo -E $stack_names | grep $stack_filter | sort -u)}")
      printf "Stacks found:\n%s\n" "${(F)filtered_stack_names[@]}"
      for stack_name in $filtered_stack_names; do
        echo ""
        echo "Getting $resource_type(s) for Stack: $stack_name"
#        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        stack_resources=$(aws cloudformation --region $R --profile $profile describe-stack-resources \
          --stack-name $stack_name \
          --query "StackResources[?ResourceType==\`$resource_type\`].PhysicalResourceId")
#        echo $stack_resources
        matching_resources+=($stack_resources)
      done
  done
  echo ""
  echo "Matching Resources:"
  echo "---------------------"
  for resource in $matching_resources; do
  if [ "$resource" != "[]" ]; then
    for r in $(echo $resource | jq -r '.[]'); do
      echo "$r"
    done
  fi
  done
}

paws () {
  echo "" \
    "876496569223 - wdpr-apps\n" \
    "795965727170 - wdpr-ia-dev\n" \
    "543276908693 - wdpr-guest360-dev\n" \
    "863175788676 - wdpr-guest360-stage\n" \
    "920268603720 - wdpr-guest360-prod\n"
}

# Russ's stuff
hello_world () {
    echo "Hello world";
}


need_aws_saml_auth() {
    if [[ $(aws s3 ls s3:// &>/dev/null; echo $?) -ne 0 ]]; then
        aws-saml-auth

        eval "$(aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com)"
    fi
}




add_ssh_keys() {
    if [[ $(ssh-add -l &>/dev/null; echo $?) -ne 0 ]] || [[ $(ssh-add -l | grep RSA | wc -l) -ne $(file $HOME/.ssh/* | grep 'private key' | wc -l) ]]; then
        local FILE=""
        for FILE in $(file $HOME/.ssh/* | grep 'private key' | cut -d: -f1); do
            \ssh-add -t 3600 $FILE >/dev/null
        done
        ssh-add -l
        trap "ssh-add -D" EXIT
    fi
}




fetch_all_git_updates() {
    echo "### Starting update $(date)"
    local START_DIR="${PWD}"
    local SEARCH_DIR="${1:-$HOME/repos}"
    local DIR=""
    for DIR in $(find "${SEARCH_DIR}" -maxdepth 5 -type d -name .git -exec dirname {} \;); do
        cd $DIR
        echo "... Updating $PWD"
        cleanup_repo n
        cd - >/dev/null
        echo "... done"
        echo
    done
    echo "### Finished update $(date)"
    cd "${START_DIR}"
}




tpm_clean_up() {
    TPM=$(find "${HOME}/repos" -name tpm.sh -type f)
    if [[ ! -x $TPM ]]; then
        echo "TPM, at ${TPM}, isn't executable!" >&2
        break
    fi
    if [[ -n "${workspace}" ]]; then
        unset workspace
    fi
    "${TPM}" clean --force
    rm -fv *.plan
}




tpm_init_and_plan() {
    need_aws_saml_auth
    add_ssh_keys
    set -u
    TPM=$(find "${HOME}/repos" -name tpm.sh -type f)
    if [[ ! -x $TPM ]]; then
        echo "TPM, at ${TPM}, isn't executable!" >&2
        return 1
    fi
    local apply="n"
    if [[ -n "${1}" ]] && [[ -e "${1}" ]]; then
        local workspace=$(echo "${1##*/}" | cut -d. -f1)
    else
        local workspace=""
        read -p "Workspace? " workspace
    fi
    if [[ ! -e "env/${workspace}.tfvars" ]]; then
        echo "No workspace file found!" >&1
        return 1
    fi
    "${TPM}" clean --force
    "${TPM}" init $workspace
    "${TPM}" plan $workspace
    read -p "Apply changes? [N/y] " -t 30 -n 1 apply
    echo
    case $apply in
        'Y'|'y')  "${TPM}" apply $workspace ;;
        *)                                  ;;
    esac
    echo "Done processing workspace ${workspace}"
    set +u
}




newhost() {
    if [[ -e $HOME/.ssh/known_hosts ]] && [[ $(grep "${1}" $HOME/.ssh/known_hosts | wc -l) -ge 1 ]]; then
        gsed -i "/${1}/d" $HOME/.ssh/known_hosts
    fi
    ssh-keyscan -T 1 -t ssh-rsa "${1}" 2>/dev/null | tee -a $HOME/.ssh/known_hosts
}




start_docker() {
    open --background -a Docker
    while [[ $(docker ps &>/dev/null ; echo $?) -ne 0 ]]; do sleep 2; done
    # docker build --tag cfn-python-lint:latest $HOME/repos/github.com/cfn-python-lint
    # docker run --network host --rm --name Portainer -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer &>/dev/null
}




stop_docker() {
    docker ps -q | xargs -I% docker stop %
    docker ps -qa | xargs -I% docker rm %
    docker images -q | xargs -I% docker rmi %
    yes|docker system prune -a
    osascript -e 'quit app "Docker"'
}



cleanup_downloads() {
    local days="${1:-365}"
    local clean='n'
    find $HOME/Downloads -type f -mtime +$days -ls
    echo "Clean? [N/y]"
    read -sq -t 3 clean
    case $clean in
        'Y'|'y') find $HOME/Downloads -type f -mtime +$days -exec rm -fv {} \; ;;
        *) ;;
    esac
}



cleanup_repo() {
    if [[ "${1}" == 'n' ]]; then
        local skip_clean="yes"
        shift
    else
        local skip_clean="no"
    fi
    if [[ $(git branch -r | grep -E '^ *origin/develop' | wc -l) -eq 1 ]]; then
        branch=${1:-develop}
    elif [[ $(git branch -r | grep -E '^ *origin/main' | wc -l) -eq 1 ]]; then
        branch=${1:-main}
    else
        branch=${1:-master}
    fi
    key_loaded=$(ssh-add -l | grep 'SHA256:VbWmYzhuSmAqusom5rfaxsonp2jQ++gZiizrqd4S54Y' | wc -l | grep -oE '[0-9]')
    [[ $key_loaded -ne 1 ]] && ssh-add -t 3600 ~/.ssh/id_rsa
    local cur_branch=$(git branch -l | grep '*' | awk '{print $NF}')
    if [[ "${cur_branch}" != "${branch}" ]]; then
        if [ $(git status -s | wc -l) -ne 0 ]; then
            echo "   ... Stashing changes"
            local stashed="true"
            git stash
        else
            local stashed="false"
        fi
        git checkout $branch
    fi
    git pull --rebase 2>/dev/null
    git fetch --all --prune
    git pull --tags -f 2>&1 1>/dev/null
    for _branch in $(git branch | grep -v '^*'); do git branch -d $_branch; done
    local full_clean="n"
    if [[ "${skip_clean}" == 'no' ]]; then
        echo -n "Full Clean? [N/y] "
        read -sq -t 3 full_clean
        echo
    fi
    case $full_clean in
        'Y'|'y')  git clean -fx ;;
    esac
    git gc --prune --quiet --aggressive
    if [[ "${cur_branch}" != "${branch}" ]]; then
        git checkout $cur_branch
        if [[ "${stashed}" = "true" ]]; then
            echo "   >>> Restoring changes"
            git stash pop >/dev/null
        fi
    fi
}



check_aws() {
    local creds=$HOME/.aws/credentials
    local expire=$(grep -E 'disney_session_expiration = ([0-9]+)' ~/.aws/credentials | grep -oP '\d+')
    if [[ 300 -gt $(expr $expire - $(date +%s)) ]]; then
        aws-saml-auth
    fi
}



change_profile() {
    local profile=$1
    if [[ $(grep $profile $HOME/.aws/credentials &>/dev/null; echo $?) -eq 0 ]]; then
    else
        echo "AWS profile $profile not found!" >&2
    fi
}



_aws_key_age() {
    local time_file="$HOME/.aws/key_upload"
    local last_time=$(cat $time_file)
    local now=$(date +%s)
    local difference=$(expr $now - $last_time)
    if [[ $difference -gt 1728000 ]]; then
        check_aws
        source ~/.aws/default
        ~/repos/ParksDataPlatform/ia-pdp-internal-team-scripts/aws-scripts/add-user-s3.py --user ander134 --admin --key "$(cat $HOME/.ssh/id_rsa.pub)"
        if [[ $? -eq 0 ]]; then
            echo $now > $time_file
        fi
    fi
}



run_atlantis() {
    action=${1:-plan}
    git remote set-head origin --auto
    branch=$(git branch | grep '*' | awk '{print $NF}')
    base=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    repo=$(echo $PWD | awk -F/ '{print $NF}')
    org=$(echo $PWD | awk -F/ '{print $(NF - 1)}')
    comments_url=$(curl -su ${USER}:$TPM_GITHUB_TOKEN "https://github.disney.com/api/v3/repos/${org}/${repo}/pulls?head=${org}:${branch}" | jq -r '.[0]["comments_url"]')
    for F in $(
        git diff --name-only $branch \
            $(git merge-base $branch $base ) | \
            grep tfvars | \
            xargs -I% -n1 bash -c '[ -f % ] && echo %'); do
        if [[ -f $F ]]; then
            _path=$(dirname $F)
            _file=$(basename $F)
            _workspace=${_file%%.*}
            if [[ -n "${2}" ]] && [[ -f "${2}" ]] && [[ "${2}" == "${F}" ]]; then
                curl -s -u ${USER}:${TPM_GITHUB_TOKEN} ${comments_url} -d "{\"body\": \"atlantis ${action} -d ${_path} -w ${_workspace} ${OPTIONS}\"}"
            elif [[ -z "${2}" ]]; then
                curl -s -u ${USER}:${TPM_GITHUB_TOKEN} ${comments_url} -d "{\"body\": \"atlantis ${action} -d ${_path} -w ${_workspace} ${OPTIONS}\"}"
            fi
        fi
    done
}



run_gen3_atlantis() {
    action=${1:-plan}
    git remote set-head origin --auto
    branch=$(git branch | grep '*' | awk '{print $NF}')
    base=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    repo=$(echo $PWD | awk -F/ '{print $NF}')
    org=$(echo $PWD | awk -F/ '{print $(NF - 1)}')
    comments_url=$(curl -su ${USER}:$TPM_GITHUB_TOKEN "https://github.disney.com/api/v3/repos/${org}/${repo}/pulls?head=${org}:${branch}" | jq -r '.[0]["comments_url"]')
    for F in $(
        git diff --name-only $branch \
            $(git merge-base $branch $base ) | \
            grep tfvars | \
            xargs -I% -n1 bash -c '[ -f % ] && echo %'); do
        if [[ -f $F ]]; then
            _path=$(dirname $F)
            _file=$(basename $F)
            _workspace=${_file%%.*}
            curl -s -u ${USER}:${TPM_GITHUB_TOKEN} ${comments_url} -d "{\"body\": \"atlantis ${action} -w ${_workspace}  ${OPTIONS}\"}"
        fi
    done
}



list_tags() {
    test -d $HOME/repos/$1 || return 1
    cd $HOME/repos/$1
    git tag -l --sort=v:refname 'v*' | tail -20
    cd -
}



find_branches() {
    for D in `find $HOME/repos -type d -name .git | sort`; do
        cd $(dirname $D)
        if [[ $(git branch -l | wc -l) -gt 1 ]]; then
            pwd
            git branch -l
            echo
        fi
        cd - > /dev/null
    done
}



format_terraform() {
    branch=$(git branch | grep '*' | awk '{print $NF}')
    base=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    for F in $(
        git diff --name-only $branch \
            $(git merge-base $branch $base ) | \
            grep -E 'tf(?:vars)?$' | \
            xargs -I% -n1 bash -c '[ -f % ] && echo %'); do
        if [[ -f $F ]]; then
            terraform fmt $F
        fi
    done
}



log_history() {
    local back_days=${1:-'1'}
    local log_path="${HOME}/OneDrive - The Walt Disney Company/logs"
    echo $back_days
    if [[ ! -f ${log_path}/zsh-history-$(/bin/date -v -${back_days}d +%Y%m%d).log ]] || [[ ! -s ${log_path}/zsh-history-$(/bin/date -v -${back_days}d +%Y%m%d).log ]]; then
        fc -li 0 | grep $(/bin/date -v -${back_days}d +%F) | tee ${log_path}/zsh-history-$(/bin/date -v -${back_days}d +%Y%m%d).log
    fi
}
