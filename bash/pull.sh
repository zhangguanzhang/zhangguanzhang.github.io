#!/bin/bash
[ -z "$set_e" ] && set -e

[ -z "$1" ] && { echo '$1 is not set';exit 2; }



# imgFullName 
sync_pull(){
    local targetName pullName
    targetName=$1
    pullName=${1//k8s.gcr.io/gcr.io\/google_containers}
    pullName=${pullName//google-containers/google_containers}
#    if [ $( tr -dc '/' <<< $pullName | wc -c) -gt 2 ];then #大于2为gcr的超长镜像名字
#        pullName=$(echo $pullName | sed -r 's#io#azk8s.cn#')
#    else
        pullName=zhangguanzhang/${pullName//\//.}
#    fi
    docker pull $pullName
    docker tag $pullName $targetName
    docker rmi $pullName
}

if [ "$1" == search ];then
    shift
    which jq &> /dev/null || { echo 'search needs jq, please install the jq';exit 2; }
    img=${1%/}
    [[ $img == *:* ]] && img_name=${img/://} || img_name=$img
    if [[ "$img" =~ ^gcr.io|^k8s.gcr.io ]];then
        if [[ "$img" =~ ^k8s.gcr.io ]];then
            img_name=${img_name/k8s.gcr.io\//gcr.io/google_containers/}
        elif [[ "$img" == *google-containers* ]]; then
            img_name=${img_name/google-containers/google_containers}
        fi
        repository=gcr.io
    elif [[ "$img" =~ ^quay.io ]];then
            repository=quay.io 
    else 
        echo 'not sync the namespaces!';exit 0;
    fi
    #echo '查询用的github,GFW原因可能会比较久,请确保能访问到github'
    curl -sX GET https://api.github.com/repos/zhangguanzhang/${repository}/contents/$img_name?ref=develop |
        jq -r 'length as $len | if $len ==2 then .message elif $len ==12 then .name else .[].name  end'
else
    img=$1

    if [[ "$img" =~ ^gcr.io|^quay.io|^k8s.gcr.io|^docker.elastic.co ]];then
        sync_pull $1
    else
        echo 'not sync the namespaces!';exit 0;
    fi
fi


