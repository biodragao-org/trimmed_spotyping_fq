#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
#==============================================
code documentation
#==============================================
*/

/*
#==============================================
params
#==============================================
*/

params.resultsDir = 'results/spotyping'
params.saveMode = 'copy'
params.filePattern = "./*_{R1,R2}*.fastq.gz"
params.query = true

/*
#==============================================
spotyping
#==============================================
*/


process SPOTYPING {
    publishDir params.resultsDir, mode: params.saveMode

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    path('*.txt')
    path('SITVIT*.xls'),  optional:true

    script:
    def query_arg = params.query ? "" : "--noQuery"

    """
    SpoTyping.py  ${genomeReads[0]} ${genomeReads[1]} -o ${genomeName}.txt ${query_arg}
    """

}


workflow {

    input = Channel.fromFilePairs(params.filePattern)

    SPOTYPING(input)

}
