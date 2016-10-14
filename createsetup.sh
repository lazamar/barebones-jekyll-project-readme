cat > .git/hooks/pre-push << EOF
#!/bin/sh
we_are_in_gh_pages="\$(git branch | grep -G '* gh-pages')"

if [ ! we_are_in_gh-pages ];
  then
    echo "Workeddddddddddddd"
    git checkout gh-pages &&
    git rebase master &&
    git push -f &&
    git checkout master # go back to master branch
  else
    echo "didn't workkkkkkkkkkkkkkkkkkkkkkkkkkk"
fi
EOF

chmod 775 .git/hooks/pre-push
