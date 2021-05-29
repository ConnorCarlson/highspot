Highspot Coding Exercise
===================================

Welcome to the Highspot interview process! For this exercise, you will be creating a command-line batch application. Highspot's product depends on both a rich web service and on batch processing — for internal use, for our customers, and for partner integrations — so this exercise is relevant to real-life Highspot engineering work. During in-person interviews, we may use your code as a discussion point. This should take a few hours to complete.

## Overview

For this exercise, you're creating a mixtape application which runs from the command line. It modifies playlists based on a set of changes. Given an input file which contains information about songs, playlists, and users, the application ingests a set of changes and produces an output file, which contains the changes applied to the input file.

In the instructions below, we provide you with the input JSON file called `mixtape.json`. We also provide an example file that contains a sample set of changes `changes.json`. (In the Ruby project, these files are found under the `example` directory `example/mixtape.json` and `example/changes.json`).

You will write the code that processes the specified changes and outputs a new file. The sample `changes.json` contains the format of the supported changes (an array of hashes). As you can see, there are three types of changes to be processed: `add_song_to_playlist`, `add_playlist`, and `remove_playlist`. 


 If you choose to use this Ruby project, make sure to use `ruby 2.6.5`.

 To set up the project and install necessary gems, please run the command from root directory of this project: 

    $ bin/setup

 To run your application, run this command:

    $ bin/mixtape example/mixtape.json example/changes.json output.json


## Background

### Why a take-home exercise?

In our experience take-home exercises, compared to technical phone screens, are more objective, and they facilitate a more equitable interview process.

Furthermore, in the normal course of software development, you have the freedom to mine your previous assignments, search Stack Exchange and Google, solicit advice from friends and relatives, and engage in quiet contemplation in order to solve problems. We do that too, and we'd like to see you exhibit a real-world-style work product.

### How much time should I invest?

Highspot devs have completed this exercise ourselves, and we think that a few hours of development time is reasonable for an experienced engineer. Spend more or less time on this, it's up to you. You can use this exercise to illustrate your talents!

We respect your time and we will accept and review any solution you submit. If you can't invest the time to show us your best work we're open to discussing alternatives.

## Considerations

### Logistics

  * Keep it simple: focus on implementing the set of changes enumerated below. Please do not handle any other operation types besides the types specified in changes.json. 
  * Assume that other people have to run, read, and support your code, that we're going to run tests against it, and that future assignments will build upon it.
  * Feel free to use this Ruby project as a starter kit. But if you prefer, use any language, tools, or solutions you see fit (e.g. Python, Clojure, or other dynamic programming language).

## OK, let's go!

### Project Requirements

Here are the basic parameters for this exercise:

  1. This input JSON file consists of a set of users, songs, and playlists that are part of a music service: https://gist.githubusercontent.com/jmodjeska/0679cf6cd670f76f07f1874ce00daaeb/raw/a4ac53fa86452ac26d706df2e851fb7d02697b4b/mixtape-data.json. (This is exactly the same data in `example/mixtape.json`)
  1. Your application ingests `mixtape.json`.
  1. Your application ingests a changes file (an example file provided as `example/changes.json`). As seen in the file, the changes file includes multiple types of changes.
  1. Your application outputs `output.json` in the same structure as `mixtape.json`, with the changes applied. The types of changes you need to support are described below and the application should process all changes in order in one pass.
  1. Your solution includes a README that explains how to use your application as needed (if you decide to use a different language or if there are other necessary instructions to run your application).
  1. Don't worry about creating a UI, DB, server, or deployment.
  1. Your code should be executable on Mac or Linux.

As seen in `example/changes.json`, the types of changes your application needs to support are:

  1. Add an existing song to an existing playlist.
  1. Add a new playlist for an existing user; the playlist should contain at least one existing song.
  1. Remove an existing playlist.

If you decide to use this Ruby project, you will have to write code to implement the apply_changes function in the lib/mixtape.rb file.

Bonus:
  1. Add tests for your application. If you decide to use this Ruby project, feel free to update the `spec/mixtape_spec.rb`. There is a sample test provided called `spec/mixtape/cli_spec.rb` if you are curious on how to write rspec tests! 
     To run all tests, please run the following command:

          $ rspec
     
     To run a specific test:
     
         $ rspec <path-to-spec-file>
     
      e.g.
     
         $ rspec spec/mixtape/cli_spec.rb 
 
      or

         $ rspec spec/mixtape_spec.rb
    
  1. In your README, describe what changes you would need to make in order to scale this application to handle very large input files and/or very large changes files. Just describe the changes — you don't actually need to implement a scaled-up version of the application.

### Project Delivery

Send your working code by email along with your README which should also include instructions for how to run your project, including instructions about any dependencies (e.g. if you decide to not use this project, please specify).  

## What happens next?

After you submit your code, we will evaluate it, and contact you about next steps, which may involve further elaboration on your code submission.

Thanks again for your time and we look forward to receiving your reply.

_The Highspot Engineering Team_
