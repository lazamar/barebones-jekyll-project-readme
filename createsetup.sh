cat > .git/hooks/pre-push << EOF
#!/bin/sh
git checkout gh-pages &&
git rebase master &&
git push -f &&
git checkout master # go back to master branch
EOF

chmod 775 .git/hooks/pre-push
