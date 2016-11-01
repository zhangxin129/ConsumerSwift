#!/bin/sh

#  MergeLanguageFiles.sh
#
#  Created by wangfd on 16/3/18.
#  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
#

language="zh-Hans en zh-Hant"
language_file="${SRCROOT}/HSConsumer/${language}.lproj/Localizable.strings"
lang_files=`find ${SRCROOT} -name "*.${language}.lang"`
tmp_file=~/xx.lang
gl=0
glt=0


for lang in $language
do

    language_file="${SRCROOT}/HSConsumer/${lang}.lproj/Localizable.strings"
    lang_files=`find ${SRCROOT} -name "*.${lang}.lang"`
    gl=0
    glt=0

    if [ -z "$lang_files" ]
    then
        exit 1
    fi

    echo '' > $language_file
    echo '' > $tmp_file

    for f in $lang_files
    do
        gl=`grep -n "/\* /global" $f  | head -n1 | cut -d : -f 1`
        gl=$(($gl-1))

        if [ $gl -gt 0 ]
        then
            head -n${gl} $f >> $tmp_file
        fi
    done

    (cat $tmp_file | sort | uniq -f 1 ) >> $language_file
    echo  '' >> $language_file
    rm $tmp_file

    for f in $lang_files
    do
        gl=`grep -n "/\* /global" $f  | head -n1 | cut -d : -f 1`
        gl=$(($gl-0))

        if [ $gl -gt 0 ]
        then
            glt=`cat $f | wc -l`
            gl=$(($glt-$gl+1))
            echo '' >> $language_file
            echo "/* ---------- ${f}  ---------- */" >> $language_file
            tail -n${gl} $f >> $language_file
        else
            glt=`cat $f | wc -l`
            glt=$(($glt+1))
            echo '' >> $language_file
            echo "/* ---------- ${f}  ---------- */" >> $language_file
            tail -n${glt} $f >> $language_file
        fi
    done

done

echo "Merge language files complete!"