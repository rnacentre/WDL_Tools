version 1.0

workflow cellranger_vdj_create_reference {
    input {
        File input_fasta
        File input_gtf
        String genome
        File cellranger_tar_gz
        String disk_space = "100 GB"
        String memory = "32 GB"
        Int num_cpu = 8
    }

    call run_cellranger_vdj_create_reference {
        input:
            cellranger_tar_gz = cellranger_tar_gz,
            disk_space = disk_space,
            memory = memory,
            num_cpu = num_cpu,
            input_fasta = input_fasta,
            input_gtf = input_gtf,
            genome = genome
    }

    output {
        File output_reference = run_cellranger_vdj_create_reference.output_reference
    }
}

task run_cellranger_vdj_create_reference {
    input {
        File cellranger_tar_gz
        String disk_space
        String memory
        Int num_cpu
        File input_fasta
        File input_gtf
        String genome
    }

    command <<<
        set -e
        export TMPDIR=/tmp
  
        mkdir cellranger
        tar -zxf "~{cellranger_tar_gz}" -C cellranger --strip-components 1
        
        mkdir reference
        mkdir results
    
        python3 <<CODE
        import os
        import subprocess
    
        cellranger_path = os.path.join(os.getcwd(), 'cellranger')
        os.environ["PATH"] = "{}:{}".format(cellranger_path, os.environ["PATH"])
    
        def run_command(command):
            print("Executing: " + ' '.join(command))
            subprocess.check_call(command)

        fasta_path = "~{input_fasta}"
        gtf_path = "~{input_gtf}"

        mkvdjref_cmd = [
            "cellranger", "mkvdjref",
            "--genome=" + "~{genome}",
            "--fasta=" + fasta_path,
            "--genes=" + gtf_path
        ]
    
        run_command(mkvdjref_cmd)
    
        CODE

        tar -czf "~{genome}_ref.tar.gz" "~{genome}"
    >>>


    output {
        File output_reference = "~{genome}_ref.tar.gz"
    }

    runtime {
        docker: "python:3.9.19-slim-bullseye"
        cpu: num_cpu
        memory: memory
        disk: disk_space
    }
}
