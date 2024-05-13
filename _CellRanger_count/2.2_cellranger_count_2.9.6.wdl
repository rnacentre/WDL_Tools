version 1.0
#########################################
# This is a WDL File                    #
# This file was formed for CellRanger   #
# Author: Sun Hao                       #
# Date: YYYY/MM/DD 2024/03/25           #
#########################################
# Attention: If you chose use the cellranger via shell in directly ways, then bugs come.
# Thanks to Shaoqiang Li, with help of him, this WDL choose to use python

task run_cellranger_count {
    input {
        # An array of FASTQ file paths
        Array[File] fastq_file_paths
        # Tar.gz reference in this format
        File reference_genome_tar_gz
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
        # If generate bam outputs
        String no_bam
        # Perform secondary analysis of the gene-barcode matrix (dimensionality reduction, clustering and visualization). Default: false
        String secondary
        
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
        no_bam: "Optional. If not generate bam outputs? Default values 'false', means 'no'."
        secondary: "Perform secondary analysis of the gene-barcode matrix (dimensionality reduction, clustering and visualization). Default: false"
    }
    
    command {
        set -e
        run_id=$(echo "~{run_id}" | sed 's/\./_/g')
        sample=$(echo "~{sample}" | sed 's/\./_/g')
        
        mkdir transcriptome_dir
        tar xf ${reference_genome_tar_gz} -C transcriptome_dir --strip-components 1
    
        python <<CODE
        import os
        from subprocess import check_call
    
        fastq_dirs = set([os.path.dirname(f) for f in "~{sep='", "' fastq_file_paths}"])
        print(fastq_dirs)
    
        call_args = ['cellranger']
        call_args.append('count')
        call_args.append('--jobmode=local')
        call_args.append('--transcriptome=transcriptome_dir')
        call_args.append('--id=' + "~{run_id}")
        call_args.append('--sample=' + "~{sample}")
        call_args.append('--fastqs=' + ','.join(list(fastq_dirs)))
        if "~{chemistry}" != 'auto':
            call_args.append('--chemistry=' + "~{chemistry}")
        call_args.append('--disable-ui')
        if '~{no_bam}' == 'True':
            call_args.append('--no-bam')
        else:
            print('We have bam files in output directory')
        if '~{secondary}' == 'True':
            call_args.append('--nosecondary')
        else:
            print('We have secondary analysis here')
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
        docker: "quay.io/humancellatlas/secondary-analysis-cellranger:v1.0.0"
        cpu: cpu
        memory: memory
        disk: disk_space
    }
}

workflow cellranger_count_workflow {
    input {
        
        # An array of FASTQ file paths
        Array[File] fastq_file_paths
        # Tar.gz reference in this format
        File reference_genome_tar_gz
        # Sample/Run ID, for this WDL,
        # we difined that each lanes' output files as a run: per run pre CellRanger job.
        String run_id
        # Required. Sample name as specified in the sample sheet supplied to cellranger mkfastq.
        String sample
        # Memory string, e.g. 120G
        String memory = "125 GB"
        # Disk space in GB
        String disk_space = "500 GB"
        # Number of cpus per cellranger job
        Int cpu = 8
        # chemistry of the channel
        String chemistry = "auto"
        # If generate bam outputs
        String no_bam = "False"
        # Perform secondary analysis of the gene-barcode matrix (dimensionality reduction, clustering and visualization). Default: false
        String secondary = "False"
        
    }

    call run_cellranger_count {
        input:
            fastq_file_paths = fastq_file_paths,
            reference_genome_tar_gz = reference_genome_tar_gz,
            run_id = run_id,
            sample = sample,
            memory = memory,
            cpu = cpu,
            disk_space = disk_space,
            no_bam = no_bam,
            chemistry = chemistry,
            secondary = secondary,
    }
}
