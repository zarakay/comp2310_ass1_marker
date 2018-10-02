# COMP2310 Assignment 1 Marker

Useful script for marking the first COMP2310 assignment

## Usage

This requires Ruby to be installed. At least 2.4+. 

To use the script do the following

1. Add all submission zips into the submissions folder
2. Unzip the contents of the default assignment template in the base folder. You should see the `gpr` files in side the base folder.
3. Go into the `base/Sources` folder and delete the `Student_Packages` Folder

Once the above is complete you are ready to go.

```shell
# Default behavior, sets up base with students assignment
# and enables default swarm mode
# open gps and pdf

./mark u1234567

# Do second swarm behavior

./mark u1234567 b

# Get Help

./mark help
```