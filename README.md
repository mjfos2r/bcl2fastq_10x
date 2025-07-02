# bcl2fastq_10x

This is the repository for the workflow to be used in processing illumina runs where libraries have been prepared using 10x.

```bash
bcl2fastq \
    --runfolder-dir <decompressed_tarball> \
    --output-dir <path_to_output_dir> \
    -w <write_threads> \
    -r <read_threads> \
    --use-bases-mask <basemask-format-string> \
    --create-fastq-for-index-reads <?>
```

28M22S10B10B50T == picard read structure format string.

Y28,n22,I10,I10,Y50 == illumina base masking format string.
