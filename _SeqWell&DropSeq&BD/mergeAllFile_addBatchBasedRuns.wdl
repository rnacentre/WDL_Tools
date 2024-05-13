version 1.0

task MergeH5AD {
    input {
        Array[File] h5ad_files
        String output_filename = "merged.h5ad"
        String disk_space = "10 GB"
        Int cpu = 2
        String memory = "16 GB"
    }

    command <<<
        set -e
        python3 <<CODE
        import scanpy as sc

        # Read the input file paths from WDL
        h5ad_files = "~{sep=',' h5ad_files}".split()

        # Initialize an empty list to store AnnData objects
        adata_list = []

        # Load all h5ad files and append to the list
        for filename in h5ad_files:
            adata = sc.read_h5ad(filename)
            print("Read in files")
            print(filename)
            adata_list.append(adata)

        # Concatenate all AnnData objects in the list with a batch key
        merged_adata = sc.concat(adata_list, join='outer', label='batch', keys=[str(i) for i in range(len(adata_list))])
        print(merged_adata)
        # Save the merged file
        merged_adata.write("~{output_filename}")
        CODE
    >>>

    output {
        File merged_h5ad = "~{output_filename}"
    }

    runtime {
        docker: "ooaahhdocker/py39_scanpy1-10-1"
        cpu: cpu
        memory: memory
        disk: disk_space
    }
}

