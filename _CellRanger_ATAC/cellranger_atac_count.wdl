version 1.0
##############################################
# This is a WDL File                         #
# This file was formed for CellRanger ATAC   #
# Author: Sun Hao                            #
# Date: YYYY/MM/DD 2024/04/08                #
##############################################
workflow cellranger_count_workflow {
    input {
        # An array of FASTQ file paths
        Array[File] fastq_file_paths
        # Tar.gz reference in this format
        File reference_genome_tar_gz
        # Tar.gz cellranger_atac packges
        File cellranger_atac_tar_gz
        # Sample/Run ID, for this WDL,
        # we difined that each lanes' output files as a run: per run pre CellRanger job.
        String run_id
        # Required. Sample name as specified in the sample sheet supplied to cellranger mkfastq.
        String sample
        # Memory string, e.g. 120G
        String memory = "225 GB"
        # Disk space in GB
        String disk_space = "500 GB"
        # Number of cpus per cellranger job
        Int cpu = 32
        # chemistry of the channel
        String chemistry = "auto"

        String? no_bam
        String? secondary

        Int? force_cells
        String? dim_reduce
        File? peaks

    }

    call run_cellranger_count {
        input:
            fastq_file_paths = fastq_file_paths,
            reference_genome_tar_gz = reference_genome_tar_gz,
            cellranger_atac_tar_gz = cellranger_atac_tar_gz,
            run_id = run_id,
            sample = sample,
            memory = memory,
            cpu = cpu,
            disk_space = disk_space,
            no_bam = no_bam,
            chemistry = chemistry,
            secondary = secondary,
            force_cells = force_cells,
            dim_reduce = dim_reduce,
            peaks = peaks,
    }
}

task run_cellranger_count {
    input {

        # An array of FASTQ file paths
        Array[File] fastq_file_paths
        # Tar.gz reference in this format
        File reference_genome_tar_gz
        # Tar.gz cellranger_atac packges
        File cellranger_atac_tar_gz
        # Sample/Run ID, for this WDL,
        # we difined that each lanes' output files as a run: per run pre CellRanger job.
        String run_id
        # Required. Sample name as specified in the sample sheet supplied to cellranger mkfastq.
        String sample
        # Memory string, e.g. 120G
        String memory
        # Disk space in GB
        String disk_space
        # Number of cpus per cellranger job
        Int cpu
        # chemistry of the channel
        String chemistry

        String? no_bam
        String? secondary

        # Force pipeline to use this number of cells, bypassing the cell detection algorithm
        Int? force_cells
        # Choose the algorithm for dimensionality reduction prior to clustering and tsne: 'lsa' (default), 'plsa', or 'pca'.
        String? dim_reduce
        # A BED file to override peak caller
        File? peaks

    }

    parameter_meta {
        run_id: "Required. A unique run ID string,The name is arbitrary and will be used to name the directory containing all pipeline-generated files and outputs. Only letters, numbers, underscores, and hyphens are allowed (maximum of 64 characters)."
        sample: "Required. Sample name as specified in the sample sheet supplied to cellranger mkfastq.Can take multiple comma-separated values, which is helpful if the same library was sequenced on multiple flow cells with different sample names, which therefore have different FASTQ file prefixes. Doing this will treat all reads from the library, across flow cells, as one sample."
        fastq_file_paths: "Required. Array of fastq files"
        reference_genome_tar_gz: "Required. CellRanger-compatible transcriptome reference (in tar.gz)(can be generated with cellranger mkref)"
        memory: "Required. The minimum amount of RAM to use for the Cromwell VM"
        disk_space: "Required. Amount of disk space (GB) to allocate to the Cromwell VM"
        cpu: "Required. The minimum number of cores to use for the Cromwell VM"
        chemistry: "Optional. The chemistry of the channel, e.g. V2 or V3. You could choose 'auto' of course."
    }

    command {
        set -e
        run_id=$(echo "~{run_id}" | sed 's/\./_/g')
        sample=$(echo "~{sample}" | sed 's/\./_/g')

        mkdir cellranger_atac
        tar -zxf ~{cellranger_atac_tar_gz} -C cellranger_atac --strip-components 1
        # Set PATH to include CellRanger-atac binaries
        export PATH=$(pwd)/cellranger_atac:$PATH

        # Unpack the reference genome
        mkdir transcriptome_dir
        tar xf ${reference_genome_tar_gz} -C transcriptome_dir --strip-components 1

        python <<CODE
        import os
        from subprocess import check_call

        # Convert the WDL Array[File] input to a Python list
        fastq_file_paths = ["${sep='","' fastq_file_paths}"]
        fastq_dirs = set([os.path.dirname(f) for f in fastq_file_paths])
        print(fastq_dirs)

        call_args = ['cellranger-atac']
        call_args.append('count')
        call_args.append('--jobmode=local')
        call_args.append('--reference=transcriptome_dir')
        call_args.append('--id=' + "~{run_id}")
        call_args.append('--fastqs=' + ','.join(list(fastq_dirs)))
        call_args.append('--sample=' + "~{sample}")
        if '~{force_cells}' != '':
            call_args.append('--force-cells=~{force_cells}')
        if '~{dim_reduce}' != '':
            call_args.append('--dim-reduce=~{dim_reduce}')
        if '~{peaks}' != '':
            call_args.append('--peaks=~{peaks}')
        if "~{chemistry}" != 'auto':
            call_args.append('--chemistry=' + "~{chemistry}")
        if '~{no_bam}' == 'True':
            call_args.append('--no-bam')
        else:
            print('We have bam files in output directory')
        if '~{secondary}' == 'True':
            call_args.append('--nosecondary')
        else:
            print('We have secondary analysis here')
        call_args.append('--disable-ui')
        print('Executing:', ' '.join(call_args))
        check_call(call_args)
        CODE

        tar -czvf ~{run_id}_outs.tar.gz ~{run_id}/outs
    }

    output {
        File output_count_directory = "~{run_id}_outs.tar.gz"
        File output_metrics_summary = "~{run_id}/outs/metrics_summary.csv"
        File output_web_summary = "~{run_id}/outs/web_summary.html"
    }

    runtime {
        docker: "python:3.9.19-slim-bullseye"
        cpu: cpu
        memory: memory
        disk: disk_space
    }
}

