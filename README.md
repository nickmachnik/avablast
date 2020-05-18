# avablast

Avablast is a small wrapper around [ncbi-blast](https://blast.ncbi.nlm.nih.gov/Blast.cgi) that simplifies running all-vs-all local BLAST searches on systems using SLURM.

## Dependencies

This code is written for [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) and requires Python 3 and a local copy of [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download).

## Installing

Simply clone this repo:
```
git clone https://github.com/nickmachnik/avablast
```

For convenience, you can add the `avablast.sh ` to your PATH:
```
export PATH="[DIRECTORY YOU CLONED AVABLAST TO]:$PATH"
```

## Geting started

To run an all-vs-all blastp search, you will need a [FASTA](https://en.wikipedia.org/wiki/FASTA_format) file with all input sequences.
From this, make a blastdb:

```
makeblastdb -in <YOUR_FASTA_FILE> -dbtype prot -out <YOUR_DB_NAME>
```

Then run avablast 
```
avablast.sh  <YOUR_DB_NAME> <YOUR_FASTA_FILE> <number of single jobs to run> <number of threads per job> <RAM in Gb per job> <output directory>
```

> NOTE: Make sure that the BLAST version you use for making the db is the same that is loaded by avablast (check the `submit_batch.sh` script).
> It assumes that dependencies can be loaded via [`module load`](http://modules.sourceforge.net/).
> If you have a different system for loading environment modules, simply replace these lines.

## License

MIT license ([LICENSE](LICENSE.txt) or https://opensource.org/licenses/MIT)

<!-- 
End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc

 -->