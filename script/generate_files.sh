#!/usr/bin/env bash

template_dir="../templates"

generate_file() {
    data_file=$1
    template_dir=$2
    template_file=$3
    out_file=$(echo "$template_file" | sed "s#$template_dir/##" | sed "s#.j2##" )
    out_dir=${out_file%\/*}

    case "$out_file" in
        *_q1.yml) return ;;
    esac

    if test -f "$out_file" ; then
      # Check if file has "no-update" marker
      if grep -q "^# JINJA2_IGNORE$" "$out_file"; then
        echo "Skipping $out_file (marked as ignore)"
        return
      fi

      echo -n "Generating $out_file ... "
      if test ! -f "$out_dir" ; then
        mkdir -p "$out_dir"
      fi
      jinja2 --strict "$template_file" "$data_file" > "$out_file"
      if git diff --exit-code -s "$out_file" ; then
        echo unchanged.
      else
        echo CHANGED!
      fi
    fi
};

data_file="../template-data/$(basename "$PWD").yml"

if test ! -f "$data_file" ; then
    echo "No data-file \"$data_file\""
    exit 0
fi

export -f generate_file;
find "$template_dir" -type f -exec bash -c "generate_file $1 \"$data_file\" \"$template_dir\" {}" \;
