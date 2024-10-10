version 1.0

task ExtractFASTQ {
    input {
        File sra_file
        File sratoolkit_tar_gz
        String sample
        String memory
        # Disk space in GB
        String disk_space
        # Number of CPUs per job
        Int cpu
        String lane
        # Split option for fasterq-dump
        String split_option
    }
    command <<<
        /root/rustSra2gz \
            --sample '~{sample}' \
            --lane '~{lane}' \
            --cpu ~{cpu} \
            --sratoolkit-tar-gz '~{sratoolkit_tar_gz}' \
            --sra-file '~{sra_file}' \
            --split-option='~{split_option}'
    >>>
    
    output {
        Array[File] fastq_files = glob("./*.fastq.gz")
        String sample_out = sample
    }
    runtime {
        docker: "registry-vpc.miracle.ac.cn/gznl/ooaahhdocker/rust_base:3.0"
        cpu: cpu
        memory: memory
        disk: disk_space
    }
}

workflow ProcessSRA {
    input {
        File sra_file
        File sratoolkit_tar_gz = "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/RAW/sratoolkit.3.1.0-ubuntu64.tar.gz" 
        String sample
        String memory = "8 GB"
        String disk_space = "300 GB"
        Int cpu = 8
        String lane = "L001"
        # Split option for fasterq-dump with default value
        String split_option = "--split-files"
    }
    call ExtractFASTQ {
        input:
            sra_file = sra_file,
            sratoolkit_tar_gz = sratoolkit_tar_gz,
            sample = sample,
            cpu = cpu,
            memory = memory,
            disk_space = disk_space,
            lane = lane,
            split_option = split_option
    }
    output {
        Array[File] fastq_files = ExtractFASTQ.fastq_files
    }
}
