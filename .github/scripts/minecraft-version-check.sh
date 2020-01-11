#!/bin/bash

        _folder=${1:-''}
        _autoupdate=${2:-'false'}
        
        echo $_folder
        echo $_autoupdate
        
        uname -a
        #ls -la 
        verlte() {
            [  "$1" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
        }

        verlt() {
            [ "$1" = "$2" ] && return 1 || verlte $1 $2
        }

        # read current MCVER adn FORGEVER
        MCVER=`cat $_folder/settings.cfg | grep MCVER | awk -F'=' '{print $2}'`
        FORGEVER=`cat $_folder/settings.cfg | grep FORGEVER | awk -F'=' '{print $2}'`

        # echo "MCVER "$MCVER
        # echo "FORGEVER "$FORGEVER
        
        # Get versions from page
        cur_site_version=`curl -qs https://files.minecraftforge.net/maven/net/minecraftforge/forge/ | grep 'Downloads for Minecraft Forge - MC' | grep -oP '(?<=<h1>).*?(?=</h1>)' | awk -F'Downloads for Minecraft Forge - MC ' '{print $2}'`
        # echo "PAGEVER "$cur_site_version
        
        if verlte $cur_site_version $MCVER; then
        # MCVER is bigger then cur_site_version	
        # echo "true"

        latest_MCVER_on_site=`curl -qs https://files.minecraftforge.net/maven/net/minecraftforge/forge/ | grep -m 1 '/maven/net/minecraftforge/forge/index_' | grep -oP -m 1 '(?<=.html">).*?(?=</a>)' | grep ''`
        # latest_MCVER_on_site=`curl -qs https://files.minecraftforge.net/maven/net/minecraftforge/forge/ | grep '/maven/net/minecraftforge/forge/index_' | head -n1 `
        # echo "LATEST "$latest_MCVER_on_site

        # lates MCVER URL page.
        latest_MCVER_url=`curl -qs https://files.minecraftforge.net/maven/net/minecraftforge/forge/ | grep -m 1 '/maven/net/minecraftforge/forge/index_' | sed -n 's/.*href="\([^"]*\).*/\1/p'`
        # echo "URL "$latest_MCVER_url

        # get url lastest on page
        latest_installer_url=`curl -sq https://files.minecraftforge.net/$latest_MCVER_url | grep '(Direct Download)' | grep installer | sed -n 's/.*href="\([^"]*\).*/\1/p' | head -n1`
        # echo $latest_installer_url
        
        full_filename=$(basename -- "$latest_installer_url")
        extension="${full_filename##*.}"
        filename="${full_filename%.*}"

        #echo $filename
        #echo $full_filename
        #echo $extension

        file_MCVER=`echo $filename | awk -F'-' '{print $2}'`
        file_FORGEVER=`echo $filename | awk -F'-' '{print $3}'`

        #echo $file_MCVER
        #echo $file_FORGEVER
        #echo $file_MCVER '< - >' $MCVER 
        echo "$MCVER < - > $file_MCVER" 
        echo "$FORGEVER < - > $file_FORGEVER"

                if verlte $MCVER $file_MCVER || verlte $file_MCVER $MCVER; then
                    # echo "MCFILE eq or file is higher"

                    if verlte $FORGEVER $file_FORGEVER; then

                              if verlt $FORGEVER $file_FORGEVER; then
#                               echo "file forgever is heigher or EQ"
                                echo "update availible"
                              #echo $file_FORGEVER "< - >" $FORGEVER
#                               echo "$FORGEVER < - > $file_FORGEVER"

                                      if $_autoupdate; then
                                        echo "autoupdate"

                                        cd $_folder
                                        sed -i 's/FORGEVER=.*/FORGEVER='$file_FORGEVER'/g' settings.cfg
                                        sed -i 's/MCVER=.*/MCVER='$file_MCVER'/g' settings.cfg
                                        
                                        sed -i 's/FORGEVER=.*/FORGEVER='$file_FORGEVER'/g' readme.md
                                        sed -i 's/MCVER=.*/MCVER='$file_MCVER'/g' readme.md

                                        chmod +x ./.github/scripts/git-log.sh
                                        ./.github/scripts/git-log.sh

                                        # git update
                                        git config --global user.name MinecraftAutoUpdater
                                        git config --global user.email mincecraft@legendsandmasters.nl
                                        git remote add github "https://CoolZeroNL:$GITHUB_TOKEN@github.com/CoolZeroNL/$_folder.git"
                                        git pull github ${GITHUB_REF} --ff-only
                                        git add .
                                        git commit -m "AutoUpdate"
                                        if [[ "$(git push github HEAD:${GITHUB_REF} --porcelain)" == *"Done"* ]]
                                        then
                                          echo "git push was successful!"
                                        else
                                          exit 2
                                        fi
                                      else
                                        exit 2
                                      fi

                              fi

                    fi
                fi
        fi
        
        

