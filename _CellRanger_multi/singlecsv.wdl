version 1.0

task cellranger_multi {
    input {
        String run_id
        File gene_expression_ref_tar_gz = "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/RAW/refdata-cellranger-GRCh38-3.0.0.tar.gz"
        File VDJ_ref_tar_gz = "s3://bioos-wcnjupodeig44rr6t02v0/analysis/sco5tra5eig49htini970/cellranger_vdj_create_reference/a37b5d72-994f-49a1-a28f-2569f03448f2/call-run_cellranger_vdj_create_reference/execution/dsadasd_ref.tar.gz"
        File cellranger_tar_gz = "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/cellranger-7.2.0.tar.gz"

        String output_csv_path
        String? chemistry = "auto"

        Int? expect_cells
        Int? force_cells
        Boolean? check_library_compatibility
        Boolean? include_introns
        Int? r1_length
        Int? r2_length

        # used in GUI, an array of you files, an sample with this.GE and this.VDJ.
        # which means we need adjust our data model
        Array[File]? GE_fastq_file_paths
        Array[File]? VDJ_B_fastq_file_paths
        Array[File]? VDJ_T_fastq_file_paths
        # used for local, thats we defined you different file path, means directory.
        String? GE_fastq_file_directory
        String? VDJ_B_fastq_file_directory
        String? VDJ_T_fastq_file_directory

        String GE_run_id
        Int GE_run_lanes = 1

        String? VDJ_B_run_id
        Int? VDJ_B_run_lanes = 1

        String? VDJ_T_run_id
        Int? VDJ_T_run_lanes = 1

        String memory = "235 GB"
        String disk_space = "300 GB"
        Int cpu = 32

    }


    command <<<
        set -e

        mkdir -p cellranger
        tar -zxf ~{cellranger_tar_gz} -C cellranger --strip-components 1
        export PATH=$(pwd)/cellranger:$PATH

        mkdir -p genome_dir genome_VDJ_dir
        tar xf ~{gene_expression_ref_tar_gz} -C genome_dir --strip-components 1
        tar xf ~{VDJ_ref_tar_gz} -C genome_VDJ_dir --strip-components 1
        cd genome_dir
        ls -l
        gene_expression_ref_tar_gz=$(pwd)
        echo $gene_expression_ref_tar_gz
        cd ..
        cd genome_VDJ_dir
        ls -l
        VDJ_ref_tar_gz=$(pwd)
        echo $VDJ_ref_tar_gz
        cd ..
        ls -l

        python3 <<CODE
        import csv
        import os
        from subprocess import check_call, CalledProcessError, DEVNULL, STDOUT
        fastqG_file_paths = "~{sep=',' GE_fastq_file_paths}"
        fastqB_file_paths = "~{sep=',' VDJ_B_fastq_file_paths}"
        fastqT_file_paths = "~{sep=',' VDJ_T_fastq_file_paths}"
        cpu="~{cpu}"
        run_id="~{run_id}"
        output_csv_path = "~{output_csv_path}"
        gene_expression_ref_tar_gz = "${gene_expression_ref_tar_gz}"
        VDJ_ref_tar_gz = "${VDJ_ref_tar_gz}"
        # Setup CSV file for cellranger multi configuration
        csv_file = "~{output_csv_path}"
        with open(csv_file, 'w', newline='') as file:
            writer = csv.writer(file)

            # Gene-expression section
            writer.writerow(["[gene-expression]"])
            writer.writerow(["reference", gene_expression_ref_tar_gz])
            writer.writerow(["chemistry", "~{chemistry}"])
            #writer.writerow(["create-bam", "true"]) # this worked in in Cell Ranger v8.0+
            if '~{expect_cells}' != '':
                writer.writerow(["expect-cells", ~{expect_cells}])
            if '~{force_cells}' != '':
                writer.writerow(["force-cells", ~{force_cells}])
            if '~{check_library_compatibility}' != '':
                writer.writerow(["check-library-compatibility", ~{check_library_compatibility}])
            if '~{include_introns}' != '':
                writer.writerow(["include-introns", ~{include_introns}])

            # VDJ section
            writer.writerow(["[vdj]"])
            writer.writerow(["reference", VDJ_ref_tar_gz])
            if '~{r1_length}' != '':
                writer.writerow(["r1-length", ~{r1_length}])
                writer.writerow(["r2-length", ~{r2_length}])

            # Libraries section
            writer.writerow(["[libraries]"])
            writer.writerow(["fastq_id", "fastqs", "lanes", "feature_types"])

            # GEX part
            # used in GUI
            print("For GEX")
            if fastqG_file_paths != "":
                fastq_dirs = set([os.path.dirname(f) for f in fastqG_file_paths.split(',')])
                fastq_dirs_str = ','.join(fastq_dirs)
                writer.writerow(["~{GE_run_id}", fastq_dirs_str, "~{GE_run_lanes}", "Gene Expression"])
                print(fastq_dirs_str)
            # used for local
            elif '~{GE_fastq_file_directory}' != '':
                writer.writerow(["~{GE_run_id}", "~{GE_fastq_file_directory}", "~{GE_run_lanes}", "Gene Expression"])

            # VDJ part
            # VDJ B
            print("For VDJ-B")
            if '~{VDJ_B_run_id}' != "":
                # used in GUI
                if fastqB_file_paths != "":
                    #fastq_file_paths = ["~{sep=',' VDJ_B_fastq_file_paths}"]
                    fastq_dirs = set([os.path.dirname(f) for f in fastqB_file_paths.split(',')])
                    fastq_dirs_str = ','.join(fastq_dirs)
                    writer.writerow(["~{VDJ_B_run_id}", fastq_dirs_str, "~{VDJ_B_run_lanes}", "VDJ-B"])
                # used for local
                elif '~{VDJ_B_fastq_file_directory}' != '':
                    writer.writerow(["~{VDJ_B_run_id}", "~{VDJ_B_fastq_file_directory}", "~{VDJ_B_run_lanes}", "VDJ-B"])
            # VDJ T
            print("For VDJ-T")
            if '~{VDJ_T_run_id}' != "":
                # used in GUI
                if fastqT_file_paths != "":
                    #fastq_file_paths = ["~{sep=',' VDJ_T_fastq_file_paths}"]
                    fastq_dirs = set([os.path.dirname(f) for f in fastqT_file_paths.split(',')])
                    fastq_dirs_str = ','.join(fastq_dirs)
                    writer.writerow(["~{VDJ_T_run_id}", fastq_dirs_str, "~{VDJ_T_run_lanes}", "VDJ-T"])
                # used for local
                elif '~{VDJ_T_fastq_file_directory}' != '':
                    writer.writerow(["~{VDJ_T_run_id}", "~{VDJ_T_fastq_file_directory}", "~{VDJ_T_run_lanes}", "VDJ-T"])
            print("the csv has been bulited")

        CODE
    >>>

    output {
        File csv = "~{output_csv_path}"
    }

    runtime {
        docker: "ooaahhdocker/python_pigz:1.0"
        memory: memory
        disk: disk_space
        cpu: cpu
    }
}
