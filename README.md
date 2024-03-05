# Makron

A toolkit for building Morrowind mod plugins via CI with a twist.

Based on its parent project, mockmw, Makron is a derivative specifically intended to build plugins for Starwind modders and Trenchbroom users. Makron contains a full suite of command line tools to edit and merge plugins from delta_plugin to habasi and tes3cmd. You can also use [Morrobroom](https://github.com/magicaldave/Morrobroom) to compile maps from Trenchbroom. Save for tes3cmd, all of Makron's tools are written in Rust.

#### Rationale

Starwind is an incredible mod, and provides a plethora of content for users to enjoy. However, it is also affeted by many technical problems - some inflicted by bugs and limitations of Bethesda's Construction Set, which was used to make it, and some caused simply due to the team getting better at modding over time. Futhermore, many alterations need to be made in order for the mod to function properly in multiplayer. In order to try and meet both of these needs, Makron exists to clean and merge the Starwind plugins together for singleplayer, alongside making all necessary multiplayer patches at build time separately. 

This will allow development of the merged plugin to be much more reproducible, and give a stable environment through which the mod can be fixed exactly where and how is necessary for both cases. Thus, Makron contains a multitude of tools to make any and all types of edits to a plugin that we may desire.

#### Credits

**Author**: S3ctor

**Special Thanks**:

* Benjamin Winger for making [Delta Plugin](https://gitlab.com/bmwinger/delta-plugin/)
* Johnnyhostile, for making [MockMW](https://gitlab.com/modding-openmw/mockmw), on which this CI setup was based and generally being an incredible dude
* The [Starwind](https://gitlab.com/modding-openmw/mockmw) team, for making the coolest TC ever, and being with me every step of the way on TSI.
* Everyone who's ever played The Starwind Initiative. You all are the best.
* The OpenMW team, including every contributor (for making OpenMW and OpenMW-CS)
* The Trenchbroom team, for making the most fun level editor I've ever used
* All the users in the `modding-openmw-dot-com` Discord channel on the OpenMW server for their dilligent testing <3
* Bethesda for making Morrowind

And a big thanks to the entire OpenMW and Morrowind modding communities! I wouldn't be doing this without all of you.

#### Connect

* [Discord](https://discord.gg/hN8FzWMad2)
* Email: `corleycomputerrepair at proton mail dot ch`
