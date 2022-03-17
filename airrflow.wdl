version 1.0

workflow airrflow {
	input{
		File samplesheet
		String? cprimers
		String? vprimers
		String outdir = "./results"
		String? email
		String? multiqc_title
		String? igblast_base
		String? imgtdb_base
		Boolean? save_databases
		String species = "human"
		String loci = "ig"
		String protocol = "pcr_umi"
		Int? vprimer_start
		Int? cprimer_start
		String? race_linker
		String cprimer_position = "R1"
		Boolean? index_file
		String umi_position = "R1"
		Int umi_length = 8
		Int? umi_start
		Int filterseq_q = 20
		String primer_mask_mode = "cut"
		Float primer_maxerror = 0.2
		Float primer_consensus = 0.6
		Boolean? set_cluster_threshold
		Float cluster_threshold = 0.14
		String threshold_method = "density"
		Boolean? skip_report
		Boolean? skip_lineage
		Boolean? skip_multiqc
		String igenomes_base = "s3://ngi-igenomes/igenomes"
		Boolean igenomes_ignore = true
		String custom_config_version = "master"
		String custom_config_base = "https://raw.githubusercontent.com/nf-core/configs/master"
		String? hostnames
		String? config_profile_name
		String? config_profile_description
		String? config_profile_contact
		String config_profile_url = "./results/pipeline_info"
		Int max_cpus = 16
		String max_memory = "128.GB"
		String max_time = "240.h"
		Boolean? help
		String publish_dir_mode = "copy"
		String? email_on_fail
		Boolean? plaintext_email
		String max_multiqc_email_size = "25.MB"
		Boolean? monochrome_logs
		String? multiqc_config
		String tracedir = "./results/pipeline_info"
		Boolean validate_params = true
		Boolean? show_hidden_params
		Boolean? enable_conda
		Boolean? singularity_pull_docker_container

	}

	call make_uuid as mkuuid {}
	call touch_uuid as thuuid {
		input:
			outputbucket = mkuuid.uuid
	}
	call run_nfcoretask as nfcoretask {
		input:
			samplesheet = samplesheet,
			cprimers = cprimers,
			vprimers = vprimers,
			outdir = outdir,
			email = email,
			multiqc_title = multiqc_title,
			igblast_base = igblast_base,
			imgtdb_base = imgtdb_base,
			save_databases = save_databases,
			species = species,
			loci = loci,
			protocol = protocol,
			vprimer_start = vprimer_start,
			cprimer_start = cprimer_start,
			race_linker = race_linker,
			cprimer_position = cprimer_position,
			index_file = index_file,
			umi_position = umi_position,
			umi_length = umi_length,
			umi_start = umi_start,
			filterseq_q = filterseq_q,
			primer_mask_mode = primer_mask_mode,
			primer_maxerror = primer_maxerror,
			primer_consensus = primer_consensus,
			set_cluster_threshold = set_cluster_threshold,
			cluster_threshold = cluster_threshold,
			threshold_method = threshold_method,
			skip_report = skip_report,
			skip_lineage = skip_lineage,
			skip_multiqc = skip_multiqc,
			igenomes_base = igenomes_base,
			igenomes_ignore = igenomes_ignore,
			custom_config_version = custom_config_version,
			custom_config_base = custom_config_base,
			hostnames = hostnames,
			config_profile_name = config_profile_name,
			config_profile_description = config_profile_description,
			config_profile_contact = config_profile_contact,
			config_profile_url = config_profile_url,
			max_cpus = max_cpus,
			max_memory = max_memory,
			max_time = max_time,
			help = help,
			publish_dir_mode = publish_dir_mode,
			email_on_fail = email_on_fail,
			plaintext_email = plaintext_email,
			max_multiqc_email_size = max_multiqc_email_size,
			monochrome_logs = monochrome_logs,
			multiqc_config = multiqc_config,
			tracedir = tracedir,
			validate_params = validate_params,
			show_hidden_params = show_hidden_params,
			enable_conda = enable_conda,
			singularity_pull_docker_container = singularity_pull_docker_container,
			outputbucket = thuuid.touchedbucket
            }
		output {
			Array[File] results = nfcoretask.results
		}
	}
task make_uuid {
	meta {
		volatile: true
}

command <<<
        python <<CODE
        import uuid
        print("gs://truwl-internal-inputs/nf-airrflow/{}".format(str(uuid.uuid4())))
        CODE
>>>

  output {
    String uuid = read_string(stdout())
  }
  
  runtime {
    docker: "python:3.8.12-buster"
  }
}

task touch_uuid {
    input {
        String outputbucket
    }

    command <<<
        echo "sentinel" > sentinelfile
        gsutil cp sentinelfile ~{outputbucket}/sentinelfile
    >>>

    output {
        String touchedbucket = outputbucket
    }

    runtime {
        docker: "google/cloud-sdk:latest"
    }
}

task fetch_results {
    input {
        String outputbucket
        File execution_trace
    }
    command <<<
        cat ~{execution_trace}
        echo ~{outputbucket}
        mkdir -p ./resultsdir
        gsutil cp -R ~{outputbucket} ./resultsdir
    >>>
    output {
        Array[File] results = glob("resultsdir/*")
    }
    runtime {
        docker: "google/cloud-sdk:latest"
    }
}

task run_nfcoretask {
    input {
        String outputbucket
		File samplesheet
		String? cprimers
		String? vprimers
		String outdir = "./results"
		String? email
		String? multiqc_title
		String? igblast_base
		String? imgtdb_base
		Boolean? save_databases
		String species = "human"
		String loci = "ig"
		String protocol = "pcr_umi"
		Int? vprimer_start
		Int? cprimer_start
		String? race_linker
		String cprimer_position = "R1"
		Boolean? index_file
		String umi_position = "R1"
		Int umi_length = 8
		Int? umi_start
		Int filterseq_q = 20
		String primer_mask_mode = "cut"
		Float primer_maxerror = 0.2
		Float primer_consensus = 0.6
		Boolean? set_cluster_threshold
		Float cluster_threshold = 0.14
		String threshold_method = "density"
		Boolean? skip_report
		Boolean? skip_lineage
		Boolean? skip_multiqc
		String igenomes_base = "s3://ngi-igenomes/igenomes"
		Boolean igenomes_ignore = true
		String custom_config_version = "master"
		String custom_config_base = "https://raw.githubusercontent.com/nf-core/configs/master"
		String? hostnames
		String? config_profile_name
		String? config_profile_description
		String? config_profile_contact
		String config_profile_url = "./results/pipeline_info"
		Int max_cpus = 16
		String max_memory = "128.GB"
		String max_time = "240.h"
		Boolean? help
		String publish_dir_mode = "copy"
		String? email_on_fail
		Boolean? plaintext_email
		String max_multiqc_email_size = "25.MB"
		Boolean? monochrome_logs
		String? multiqc_config
		String tracedir = "./results/pipeline_info"
		Boolean validate_params = true
		Boolean? show_hidden_params
		Boolean? enable_conda
		Boolean? singularity_pull_docker_container

	}
	command <<<
		export NXF_VER=21.10.5
		export NXF_MODE=google
		echo ~{outputbucket}
		/nextflow -c /truwl.nf.config run /airrflow-2.0.0  -profile truwl  --input ~{samplesheet} 	~{"--samplesheet " + samplesheet}	~{"--cprimers " + cprimers}	~{"--vprimers " + vprimers}	~{"--outdir " + outdir}	~{"--email " + email}	~{"--multiqc_title " + multiqc_title}	~{"--igblast_base " + igblast_base}	~{"--imgtdb_base " + imgtdb_base}	~{true="--save_databases  " false="" save_databases}	~{"--species " + species}	~{"--loci " + loci}	~{"--protocol " + protocol}	~{"--vprimer_start " + vprimer_start}	~{"--cprimer_start " + cprimer_start}	~{"--race_linker " + race_linker}	~{"--cprimer_position " + cprimer_position}	~{true="--index_file  " false="" index_file}	~{"--umi_position " + umi_position}	~{"--umi_length " + umi_length}	~{"--umi_start " + umi_start}	~{"--filterseq_q " + filterseq_q}	~{"--primer_mask_mode " + primer_mask_mode}	~{"--primer_maxerror " + primer_maxerror}	~{"--primer_consensus " + primer_consensus}	~{true="--set_cluster_threshold  " false="" set_cluster_threshold}	~{"--cluster_threshold " + cluster_threshold}	~{"--threshold_method " + threshold_method}	~{true="--skip_report  " false="" skip_report}	~{true="--skip_lineage  " false="" skip_lineage}	~{true="--skip_multiqc  " false="" skip_multiqc}	~{"--igenomes_base " + igenomes_base}	~{true="--igenomes_ignore  " false="" igenomes_ignore}	~{"--custom_config_version " + custom_config_version}	~{"--custom_config_base " + custom_config_base}	~{"--hostnames " + hostnames}	~{"--config_profile_name " + config_profile_name}	~{"--config_profile_description " + config_profile_description}	~{"--config_profile_contact " + config_profile_contact}	~{"--config_profile_url " + config_profile_url}	~{"--max_cpus " + max_cpus}	~{"--max_memory " + max_memory}	~{"--max_time " + max_time}	~{true="--help  " false="" help}	~{"--publish_dir_mode " + publish_dir_mode}	~{"--email_on_fail " + email_on_fail}	~{true="--plaintext_email  " false="" plaintext_email}	~{"--max_multiqc_email_size " + max_multiqc_email_size}	~{true="--monochrome_logs  " false="" monochrome_logs}	~{"--multiqc_config " + multiqc_config}	~{"--tracedir " + tracedir}	~{true="--validate_params  " false="" validate_params}	~{true="--show_hidden_params  " false="" show_hidden_params}	~{true="--enable_conda  " false="" enable_conda}	~{true="--singularity_pull_docker_container  " false="" singularity_pull_docker_container}	-w ~{outputbucket}
	>>>
        
    output {
        File execution_trace = "pipeline_execution_trace.txt"
        Array[File] results = glob("results/*/*html")
    }
    runtime {
        docker: "truwl/nfcore-airrflow:2.0.0_0.1.0"
        memory: "2 GB"
        cpu: 1
    }
}
    