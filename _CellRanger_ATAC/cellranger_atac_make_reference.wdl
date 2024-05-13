version 1.0
############################################################
# This is a WDL File                                       #
# This file was formed for CellRanger ATAC make reference  #
# Author: Sun Hao                                          #
# Date: YYYY/MM/DD 2024/04/08                              #
############################################################
task run_cellranger_atac_make_reference {
    input {
        # Tar.gz cellranger_atac packges
        File cellranger_atac_tar_gz

        # Memory string, e.g. 120G
        String memory
        # Disk space in GB
        String disk_space
        # Number of cpus per cellranger job
        Int cpu

        # Organism name
        String organism
        # Genomes' name
        String genome
        # Path for input fasta file
        File fasta
        # Path for input GTF file
        File gtf
        # A comma separated list of names of contigs that are not in nucleus
        String? non_nuclear_contigs
        # Optional file containing transcription factor motifs in JASPAR format
        File? input_motifs
    }

    command {
        set -e

        mkdir cellranger_atac
        tar -zxf ${cellranger_atac_tar_gz} -C cellranger_atac --strip-components 1
        # Set PATH to include CellRanger binaries
        export PATH=$(pwd)/cellranger_atac:$PATH

        python <<CODE
        with open("config.json", "w") as fout:
            fout.write("{\n")
            if '~{organism}' != "":
                fout.write("    organism: \"~{organism}\"\n")
            fout.write("    genome: [\"~{genome}\"]\n")
            fout.write("    fasta: [\"~{fasta}\"]\n")
            fout.write("    gtf: [\"~{gtf}\"]\n")
            if '~{non_nuclear_contigs}' != "":
                fout.write("    non_nuclear_contigs: [" + ", ".join(['"' + x + '"' for x in '~{non_nuclear_contigs}'.split(',')]) + "]\n")
            if '~{input_motifs}' != "":
                fout.write("    input_motifs: \"~{input_motifs}\"\n")
            fout.write("\x7D\n") # '\x7D' refers to right brace bracket
        CODE

        cellranger-atac mkref --config=config.json
        tar -czf ~{genome}.tar.gz ~{genome}
    }

    output {
        File output_reference = "~{genome}.tar.gz"
    }

    runtime {
        docker: "python:3.9.19-slim-bullseye"
        cpu: cpu
        memory: memory
        disk: disk_space
    }
}
workflow cellranger_atac_make_reference {
    input {
         # Tar.gz cellranger_atac packges
        File cellranger_atac_tar_gz = "s3://bioos-wcnjupodeig44rr6t02v0/cellranger-atac-2.1.0.tar.gz"

        # Memory string, e.g. 120G
        String memory
        # Disk space in GB
        String disk_space
        # Number of cpus per cellranger job
        Int cpu

        # Organism name
        String organism
        # Genomes' name
        String genome
        # Path for input fasta file
        File fasta
        # Path for input GTF file
        File gtf
        # A comma separated list of names of contigs that are not in nucleus
        String? non_nuclear_contigs
        # Optional file containing transcription factor motifs in JASPAR format
        File? input_motifs

    }

    call run_cellranger_atac_make_reference {
        input:
            cellranger_atac_tar_gz = cellranger_atac_tar_gz
            disk_space = disk_space,
            memory = memory,
            organism = organism,
            genome = genome,
            fasta = fasta,
            gtf = gtf,
            non_nuclear_contigs = non_nuclear_contigs,
            input_motifs = input_motifs
    }

    output {
        File output_reference = run_cellranger_atac_make_reference.output_reference
    }

}
