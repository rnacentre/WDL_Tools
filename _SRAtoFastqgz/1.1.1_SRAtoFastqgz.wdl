version 1.0

task run_sratoolkit_from_tar {
    input {
        File sra_file
        File sratoolkit_tar_gz
        String memory = "8 GB"
        # Disk space in GB
        String disk_space = "300 GB"
        # Number of cpus per cellranger job
        Int cpu = 2
    }

    command {
        set -e


        mkdir -p sratoolkit
        tar -xzf ${sratoolkit_tar_gz} -C sratoolkit --strip-components 1


        export PATH=$(pwd)/sratoolkit/bin:$PATH

        python <<CODE
        import os
        from subprocess import check_call

        sra_file = "${sra_file}"
        call_args = [
            'fastq-dump',
            '--split-files',
            '--gzip',
            '--outdir', '.',
            sra_file
        ]
        print('Executing:', ' '.join(call_args))
        check_call(call_args)
        CODE
    }

    output {
    Array[File] fastq_files = glob("*.fastq.gz")
}


    runtime {
        docker: "quay.io/humancellatlas/secondary-analysis-cellranger:v1.0.0"
        cpu: cpu
        memory: memory
        disk: disk_space
    }
}
