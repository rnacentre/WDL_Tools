version 1.0

task run_starsolo {
    input {
        Array[File] fastq_files
        String barcode_read = "read1"
        String assay = "SeqWell"
        File reference_tar_gz = "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/RAW/refdata-cellranger-GRCh38-3.0.0.tar.gz"
        String genome_name = "hg38_3.0.0"
        String? outSAMtype
        String? soloType
        File? soloCBwhitelist
        Int? soloCBstart
        Int? soloCBlen
        Int? soloUMIstart
        Int? soloUMIlen
        Int? soloBarcodeReadLength
        Int? soloBarcodeMate
        String? soloCBposition
        String? soloUMIposition
        String? soloAdapterSequence
        Int? soloAdapterMismatchesNmax
        String? soloCBmatchWLtype
        String? soloInputSAMattrBarcodeSeq
        String? soloInputSAMattrBarcodeQual
        String? soloStrand
        String? soloFeatures
        String? soloMultiMappers
        String? soloUMIdedup
        String? soloUMIfiltering
        String? soloCellFilter
        String? soloOutFormatFeaturesGeneField3
        String? limitBAMsortRAM
        Int? outBAMsortingBinsN
        String memory = "240 GB"
        Int num_cpu = 32
        String disk_space = "300 GB"
    }

    command {
        set -e
        export TMPDIR=/tmp
        export BACKEND=/BACKEND

        mkdir genome_ref
        tar -zxf "~{reference_tar_gz}" -C genome_ref --strip-components 8
        ls -l genome_ref
        mkdir results

        python <<CODE
        import os, re
        from fnmatch import fnmatch
        from subprocess import check_call, CalledProcessError, DEVNULL, STDOUT
        import pegasusio as io

        def generate_args_list(args_dict):
            res_list = list()
            for k, v in args_dict.items():
                if isinstance(v, list):
                    res_list.extend([k] + v)
                else:
                    res_list.extend([k, v])
            return res_list

        R1_FILE="~{fastq_files[0]}"
        R2_FILE="~{fastq_files[1]}"

        def remove_extra_space(s):
            return re.sub(' +', ' ', s.strip())

        call_args = ['/home/STAR', '--genomeDir', 'genome_ref', '--runThreadN', '~{num_cpu}', '--outFileNamePrefix', 'results/']

        barcode_read = '~{barcode_read}'
        args_dict = dict()

        if '~{assay}' in ['SeqWell', 'DropSeq']:
            args_dict['--soloType'] = 'CB_UMI_Simple'
            args_dict['--soloCBstart'] = '1'
            args_dict['--soloCBlen'] = '12'
            args_dict['--soloUMIstart'] = '13'
            args_dict['--soloUMIlen'] = '8'
            args_dict['--outSAMtype'] = ['BAM', 'SortedByCoordinate']
            args_dict['--outSAMattributes'] = ['CR', 'UR', 'CY', 'UY', 'CB', 'UB']
            barcode_read = 'read1'
        else:
            args_dict['--outSAMattributes'] = ['BAM', 'Unsorted']

        args_dict['--readFilesCommand'] = 'zcat'

        args_dict['--readFilesIn'] = [R1_FILE, R2_FILE]

        if '~{outSAMtype}' != '':
            args_dict['--outSAMtype'] = remove_extra_space('~{outSAMtype}').split(' ')
        if '~{soloType}' != '':
            args_dict['--soloType'] = '~{soloType}'

        if '~{soloCBwhitelist}' != '' and os.path.basename('~{soloCBwhitelist}') != 'null':
            fn_tup = os.path.splitext("~{soloCBwhitelist}")
            if fn_tup[1] == '.gz':
                with open(fn_tup[0], 'w') as fp:
                    check_call(['zcat', "~{soloCBwhitelist}"], stdout=fp)
                whitelist_file = fn_tup[0]
            else:
                whitelist_file = '~{soloCBwhitelist}'
            args_dict['--soloCBwhitelist'] = whitelist_file
        else:
            args_dict['--soloCBwhitelist'] = 'None'

        if '~{soloCBstart}' != '':
            args_dict['--soloCBstart'] = '~{soloCBstart}'
        if '~{soloCBlen}' != '':
            args_dict['--soloCBlen'] = '~{soloCBlen}'
        if '~{soloUMIstart}' != '':
            args_dict['--soloUMIstart'] = '~{soloUMIstart}'
        if '~{soloUMIlen}' != '':
            args_dict['--soloUMIlen'] = '~{soloUMIlen}'
        if '~{soloBarcodeReadLength}' != '':
            args_dict['--soloBarcodeReadLength'] = '~{soloBarcodeReadLength}'
        if '~{soloBarcodeMate}' != '':
            args_dict['--soloBarcodeMate'] = '~{soloBarcodeMate}'
        if '~{soloType}' == 'CB_UMI_Complex':
            if '~{soloCBposition}' != '':
                args_dict['--soloCBposition'] = remove_extra_space('~{soloCBposition}').split(' ')
            if '~{soloUMIposition}' != '':
                args_dict['--soloUMIposition'] = remove_extra_space('~{soloUMIposition}').split(' ')
        if '~{soloAdapterSequence}' != '':
            args_dict['--soloAdapterSequence'] = '~{soloAdapterSequence}'
        if '~{soloAdapterMismatchesNmax}' != '':
            args_dict['--soloAdapterMismatchesNmax'] = '~{soloAdapterMismatchesNmax}'
        if '~{soloCBmatchWLtype}' != '':
            args_dict['--soloCBmatchWLtype'] = '~{soloCBmatchWLtype}'
        if '~{soloInputSAMattrBarcodeSeq}' != '':
            args_dict['--soloInputSAMattrBarcodeSeq'] = remove_extra_space('~{soloInputSAMattrBarcodeSeq}').split(' ')
        if '~{soloInputSAMattrBarcodeQual}' != '':
            args_dict['--soloInputSAMattrBarcodeQual'] = remove_extra_space('~{soloInputSAMattrBarcodeQual}').split(' ')
        if '~{soloStrand}' != '':
            args_dict['--soloStrand'] = '~{soloStrand}'
        if '~{soloFeatures}' != '':
            feature_list = remove_extra_space('~{soloFeatures}').split(' ')
            if ('Velocyto' in feature_list) and ('Gene' not in feature_list):
                feature_list.append('Gene')
            args_dict['--soloFeatures'] = feature_list
        if '~{soloMultiMappers}' != '':
            args_dict['--soloMultiMappers'] = remove_extra_space('~{soloMultiMappers}').split(' ')
        if '~{soloUMIdedup}' != '':
            args_dict['--soloUMIdedup'] = remove_extra_space('~{soloUMIdedup}').split(' ')
        if '~{soloUMIfiltering}' != '':
            args_dict['--soloUMIfiltering'] = remove_extra_space('~{soloUMIfiltering}').split(' ')
        if '~{soloCellFilter}' != '':
            args_dict['--soloCellFilter'] = remove_extra_space('~{soloCellFilter}').split(' ')
        if '~{soloOutFormatFeaturesGeneField3}' != '':
            args_dict['--soloOutFormatFeaturesGeneField3'] = remove_extra_space('~{soloOutFormatFeaturesGeneField3}').split(' ')

        if '~{limitBAMsortRAM}' != '':
            args_dict['--limitBAMsortRAM'] = '~{limitBAMsortRAM}'
        if '~{outBAMsortingBinsN}' != '':
            args_dict['--outBAMsortingBinsN'] = '~{outBAMsortingBinsN}'

        call_args += generate_args_list(args_dict)

        print(' '.join(call_args))
        check_call(call_args)

        # Generate 10x h5 format output
        def gen_10x_h5(file_path, outname, genome):
            print("Generate 10x h5 format file of "+file_path+"...")
            data = io.read_input(file_path, genome=genome)
            io.write_output(data, outname+'.h5')

        if '~{soloFeatures}' == '':
            feature_list = ['Gene']
        for feature in feature_list:
            if not feature in ['Gene', 'GeneFull', 'Velocyto']:
                continue
            prefix = "results/Solo.out/" + feature
            f_list = os.listdir(prefix)
            if 'raw' in f_list:
                gen_10x_h5(prefix+'/raw', prefix+'/raw/'+feature, "~{genome_name}")
            if 'filtered' in f_list:
                gen_10x_h5(prefix+'/filtered', prefix+'/filtered/'+feature, "~{genome_name}")

        CODE

        tar -czvf results_outs.tar.gz results

    }

    output {
        File output_bam = "results/Aligned.sortedByCoord.out.bam"
        File output_tar_gz = "results_outs.tar.gz"
    }

    runtime {
        docker: "ooaahhdocker/starsolo2:2.0"
        memory: memory
        disk: disk_space
        cpu: num_cpu
    }
}
