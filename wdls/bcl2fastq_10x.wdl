version 1.0


## WIP


import "Structs.wdl"

task bcl2fastq {
    input {
        String run_id
        String experimentName
        File flowcell_tarball
        File samplesheet
        Int? write_threads = 4
        Int? read_threads = 4
        String readstructure
        RuntimeAttr? runtime_attr_override
    }

    parameter_meta {
        File flowcell_tarball: "tarball containing bcl files for our illumina run"
        File samplesheet: "samplesheet for this run"
    }

    Int disk_size = 365 + 10 * ceil(size(flowcell_tarball, "GB"))

    command <<<
        set -euo pipefail

        TARBALL="~{flowcell_tarball}"
        EXPERIMENTNAME="$(basename ${TARBALL%%.*})"

        tar -xzf "$TARBALL"
        cd "$EXPERIMENTNAME"

        bcl2fastq \
            --samplesheet "~{samplesheet}" \
            -w "~{write_threads}" \
            -r "~{read_threads}" \
            --use-bases-mask "~{readstructure}" \
            --create-fastq-for-index-reads

        #tar -czvf "~{run_id}.tar.gz" outdir

    >>>

    output {
        File output_tarball = "~{run_id}.tar.gz"
    }

    #########################
    RuntimeAttr default_attr = object {
        cpu_cores:          4,
        mem_gb:             8,
        disk_gb:            disk_size,
        boot_disk_gb:       10,
        preemptible_tries:  0,
        max_retries:        1,
        docker:             "image:tag"
    }
    RuntimeAttr runtime_attr = select_first([runtime_attr_override, default_attr])
    runtime {
        cpu:                    select_first([runtime_attr.cpu_cores,         default_attr.cpu_cores])
        memory:                 select_first([runtime_attr.mem_gb,            default_attr.mem_gb]) + " GiB"
        disks: "local-disk " +  select_first([runtime_attr.disk_gb,           default_attr.disk_gb]) + " HDD"
        bootDiskSizeGb:         select_first([runtime_attr.boot_disk_gb,      default_attr.boot_disk_gb])
        preemptible:            select_first([runtime_attr.preemptible_tries, default_attr.preemptible_tries])
        maxRetries:             select_first([runtime_attr.max_retries,       default_attr.max_retries])
        docker:                 select_first([runtime_attr.docker,            default_attr.docker])
    }
}