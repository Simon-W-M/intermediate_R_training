# Intermediate R Training

This is a follow on course for the Introduction to R and R Studio course or for
people who have some familiarity and comfort in using R.

## Course preparation

Data for the course is from the [{NHSRdatasets}](https://github.com/nhs-r-community/NHSRdatasets) 
package available through CRAN.
Set up information for the course can be found in the [NHS-R Way book](https://nhsrway.nhsrcommunity.com/training.html#intermediate-r).

### Contributing

Please see our 
[guidance on how to contribute](https://tools.nhsrcommunity.com/contribution.html).

This project is released with a Contributor [Code of Conduct](./CODE_OF_CONDUCT.md). 
By contributing to this project, you agree to abide by its terms.

The simplest way to contribute is to raise an issue detailing the feature or 
functionality you would like to see added, or any unexpected behaviour or bugs 
you have experienced.

## If you fork this repository

Note that because this is a forked project the following commands in git in the
Terminal are needed to reset the `origin` to NHS-R Community.
This is needed in order to create new branches to PR into `main` which is good
practice:

```
git remote remove upstream
git remote add upstream https://github.com/Simon-W-M/intermediate_R_training.git
git remote remove origin
git remote add origin https://github.com/nhs-r-community/intermediate_R_training.git
```
The command:

```
git remote -v
```

will show the links and should say:

```
origin  https://github.com/nhs-r-community/intermediate_R_training.git (fetch)
origin  https://github.com/nhs-r-community/intermediate_R_training.git (push)
upstream        https://github.com/Simon-W-M/intermediate_R_training.git (fetch)
upstream        https://github.com/Simon-W-M/intermediate_R_training.git (push)
```

Hint: copying text into the Terminal cannot use the short cut keys of Ctrl+V but
right click on the mouse.

Also note that the PR will work from the {usethis} package but will be to the 
upstream repository in GitHub and will need to be reset to 
`nhs-r-community/intermediate_R_training.git`.

## Special note of thanks

To [Simon.Wellesley-Miller](mailto:simon.wellesley-miller@nhs.net), NHS England,
for developing this course on behalf of NHS-R Community.

