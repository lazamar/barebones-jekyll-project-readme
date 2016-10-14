# Barebones Jekyll Project README

![For badge's sake](http://forthebadge.com/images/badges/no-ragrets.svg) ![For badge's sake](http://forthebadge.com/images/badges/gluten-free.svg)

This repo shows in a very simple and minimalistic way how to create show your readme file in your `Jekyll` index page.

Check it out here: [https://lazamar.github.io/barebones-jekyll-project-readme/](https://lazamar.github.io/barebones-jekyll-project-readme/)

With this setup you can immediately create a project page for any repo by just including the `_config.yml` and `index.md` files exaclty as they are here, without needing to change a single comma, and creating a `gh-pages` branch. It will automatically link to your repo and load your README.

## Problem free one time setup

If you are reeeally lazy and don't want to be copying files, you can just run this from within the repo folder. (*yes, you can just copy the whole block and paste into the terminal*)


```
# Copy our two files to the gh-pages branch
git checkout -b gh-pages &&
wget https://raw.githubusercontent.com/lazamar/barebones-jekyll-project-readme/master/_config.yml &&
wget https://raw.githubusercontent.com/lazamar/barebones-jekyll-project-readme/master/index.md &&
#
# Commit and publish our page on github
git add -A && git commit -m "Create project github page" &&
git push --set-upstream origin gh-pages |
#
git checkout master # go back to master branch
```

## Super chilled automation

And then, don't forget, every time you change your readme you have to update the `gh-pages` branch. I know you are lazy, let's automate that with another one-liner.


```
$(cat > .git/hooks/pre-push << EOF
#!/bin/sh
we_are_in_gh_pages="\$(git branch | grep -G "* gh-pages")"

if [ ! "\$we_are_in_gh_pages" ];
  then
    git checkout gh-pages &&
    git rebase master &&
    git push -f &&
    git checkout master # go back to master branch
fi
EOF
) && chmod 775 .git/hooks/pre-push
```

**That's it**. Now you have a git hook that will update your `gh-pages` branch every time you push something to github.


Here is some javascript code just to show that syntax highlighting is working in the project page and in the project `README.md` file view even though we are not using `Jekyll`'s liquid tags to set the language. (Cool eh?)


``` javascript
/**
  * Returns a promise to be resolved when all files have been linked.
  * @method linkDependenciesTo
  * @param  {String} dest - Folder where dependencies will go.
  * @param {Object} (Optional) Configuration options on how links will be created.
  * The only options available are { type: 'junction' } or { type: 'dir'} when
  * process.platform ==== 'win32'. Junctions have fewer  restrictions and are more
  * likely to succeed when running as a User. The default for type when running
  * under Windows is Junction.
  * @return {Promise} - To be resolved when all files have been copied.
  */
 linkDependenciesTo(dest, opts) {
   if (typeof dest !== 'string') {
     throw new Error(`Not a valid destination folder: ${dest}`);
   }

   const dependencies = this.listDependencies();

   opts = opts || {};

   // Only valid on win32
   const linkTypeJunction = 'junction';
   const linkTypeDir = 'dir';
   const linkType = (isWin && opts.type !== 'dir') ? linkTypeJunction : linkTypeDir;

   // Create all folders up to the destiny folder
   fs.mkdirpSync(dest);

   const linkingPromises = [];
   for (const depName of dependencies) {
     // relative paths
     const rLinkSource = path.join('./node_modules', depName);
     const rLinkDestiny = path.join(dest, depName);

     const linkSource = path.resolve(rLinkSource);
     const linkDestiny = path.resolve(rLinkDestiny);

     // Link content
     const linking = new Promise((resolve) => { // Check if file exists
       fs.access(linkDestiny, fs.F_OK, resolve);
     })
     .then((err) => new Promise((resolve) => { // Delete it if needed
       if (err) {
         // File doesn't exist, nothing to do.
         resolve();
       } else {
         // File exists, let's remove it.
         fs.unlink(linkDestiny, resolve);
       }
     }))
     .then((err) => {  // Report on errors
       if (err) { console.log(err); }
     })
     .then(() => new Promise((resolve) => { // Create simbolic link

       // In the future it is possible to utilize the 'runas' module
       // to ShellExec this command with the Verb: RunAs under Windows. The
       // ideal scenario would be for the task to prompt the user for credentials.
       fs.symlink(linkSource, linkDestiny, linkType, resolve);
     }))
     .then((err) => {  // Report on errors
       if (err) { console.log(err); }
     });

     linkingPromises.push(linking);
   }

   return Promise.all(linkingPromises);
 }
```

code from [https://www.npmjs.com/package/dep-linker](https://www.npmjs.com/package/dep-linker)
