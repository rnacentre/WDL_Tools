version 1.0

workflow cellranger_vdj {
    input {
        String sample_id
        Array[File]  fastq_file_paths
        File cellranger_tar_gz = "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/cellranger-7.2.0.tar.gz"
        File reference_tar_gz = "s3://bioos-wcnjupodeig44rr6t02v0/analysis/sco5tra5eig49htini970/cellranger_vdj_create_reference/a37b5d72-994f-49a1-a28f-2569f03448f2/call-run_cellranger_vdj_create_reference/execution/dsadasd_ref.tar.gz"
        String disk_space = "500 GB"
        String memory = "120 GB"
        Int num_cpu = 8
        Boolean denovo = false
        String chain = "auto"
    }

    call run_cellranger_vdj {
        input:
            sample_id = sample_id,
            fastq_file_paths = fastq_file_paths,
            cellranger_tar_gz = cellranger_tar_gz,
            reference_tar_gz = reference_tar_gz,
            disk_space = disk_space,
            memory = memory,
            num_cpu = num_cpu,
            denovo = denovo,
            chain = chain
    }

    output {
        File output_vdj_directory = run_cellranger_vdj.output_vdj_directory
    }
}

task run_cellranger_vdj {
    input {
        String sample_id
        Array[File]  fastq_file_paths
        File cellranger_tar_gz
        File reference_tar_gz
        String disk_space
        String memory
        Int num_cpu
        Boolean denovo
        String chain
    }

    command {
        set -e
        export TMPDIR=/tmp
        
        mkdir -p cellranger
        tar -zxf "~{cellranger_tar_gz}" -C cellranger --strip-components 1
        
        mkdir -p reference
        tar -zxf "~{reference_tar_gz}" -C reference --strip-components 1

        export PATH=$(pwd)/cellranger:$PATH
    
        python <<CODE
        import os
        from subprocess import check_call

        
        fastq_file_paths = ["~{sep='", "' fastq_file_paths}"]
       
        fastq_file_paths = fastq_file_paths[0].split('", "')
        fastq_dirs = set(os.path.dirname(f) for f in fastq_file_paths)
        print(fastq_dirs)
        
        
        call_args = [
            'cellranger', 'vdj',
            '--id', "~{sample_id}_vdj",
            '--reference', 'reference',
            '--fastqs', ','.join(list(fastq_dirs)),
            '--sample', "~{sample_id}",
            '--chain', "~{chain}",
            '--disable-ui'
        ]
        
        if '~{denovo}' == 'True':
            call_args.append('--denovo')

        print('Executing:', ' '.join(call_args))
        check_call(call_args)
        
        CODE
        
        tar -czf "~{sample_id}_vdj_output.tar.gz" "~{sample_id}_vdj/outs"
    
    }
    

    output {
        File output_vdj_directory = "~{sample_id}_vdj_output.tar.gz"
    }

    runtime {
        docker: "python:3.9.19-slim-bullseye"
        memory: memory
        disk: disk_space
        cpu: num_cpu
    }
}
