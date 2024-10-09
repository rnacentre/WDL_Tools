use clap::Parser;
use regex::Regex;
use std::collections::HashMap;
use std::env;
use std::fs;
use std::process::Command;
use glob::glob;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Sample name
    #[arg(short, long)]
    sample: String,

    /// Lane
    #[arg(short, long)]
    lane: String,

    /// Number of CPUs
    #[arg(short, long, default_value_t = 1)]
    cpu: usize,

    /// Path to sratoolkit tar.gz file
    #[arg(short, long)]
    sratoolkit_tar_gz: String,

    /// Path to SRA file
    #[arg(short, long)]
    sra_file: String,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = Args::parse();

    // Replace '.' with '_' in sample name
    let sample = args.sample.replace(".", "_");
    let lane = args.lane;

    // Create sratoolkit directory
    fs::create_dir_all("sratoolkit")?;

    // Extract sratoolkit tar.gz file
    let tar_status = Command::new("tar")
        .arg("-xzf")
        .arg(&args.sratoolkit_tar_gz)
        .arg("-C")
        .arg("sratoolkit")
        .arg("--strip-components")
        .arg("1")
        .status()?;

    if !tar_status.success() {
        eprintln!("Failed to extract sratoolkit tar.gz file.");
        std::process::exit(1);
    }

    // Update PATH to include sratoolkit/bin
    let current_dir = env::current_dir()?;
    let sratoolkit_bin = current_dir.join("sratoolkit").join("bin");
    let path_var = env::var("PATH").unwrap_or_default();
    let new_path = format!("{}:{}", sratoolkit_bin.display(), path_var);
    env::set_var("PATH", &new_path);

    // Run fasterq-dump
    let fasterq_status = Command::new("fasterq-dump")
        .arg("--split-files")
        .arg("-e")
        .arg(args.cpu.to_string())
        .arg("--include-technical")
        .arg(&args.sra_file)
        .status()?;

    if !fasterq_status.success() {
        eprintln!("Failed to run fasterq-dump.");
        std::process::exit(1);
    }

    // Find all .fastq files
    let mut files: Vec<String> = Vec::new();
    for entry in glob("*.fastq")? {
        match entry {
            Ok(path) => {
                if let Some(filename) = path.to_str() {
                    files.push(filename.to_string());
                }
            }
            Err(e) => eprintln!("Error reading file: {:?}", e),
        }
    }

    // Map files based on suffix
    let re = Regex::new(r"_(\d)\.fastq$").unwrap();
    let mut file_suffixes: HashMap<String, String> = HashMap::new();
    for f in files {
        if let Some(caps) = re.captures(&f) {
            let suffix = caps.get(1).unwrap().as_str().to_string();
            file_suffixes.insert(suffix, f);
        }
    }

    // Initialize variables to hold file paths
    let mut i1_file = None;
    let mut i2_file = None;
    let mut r1_file = None;
    let mut r2_file = None;

    match file_suffixes.len() {
        2 => {
            r1_file = file_suffixes.get("1").cloned();
            r2_file = file_suffixes.get("2").cloned();
        }
        3 => {
            i1_file = file_suffixes.get("1").cloned();
            r1_file = file_suffixes.get("2").cloned();
            r2_file = file_suffixes.get("3").cloned();
        }
        4 => {
            i1_file = file_suffixes.get("1").cloned();
            i2_file = file_suffixes.get("2").cloned();
            r1_file = file_suffixes.get("3").cloned();
            r2_file = file_suffixes.get("4").cloned();
        }
        _ => {
            eprintln!("Unexpected number of .fastq files.");
            std::process::exit(1);
        }
    }

    // Define new filenames and list to compress
    let mut new_filenames: Vec<String> = Vec::new();

    if let Some(ref i1) = i1_file {
        let i1_new_filename = format!("{}_S1_{}_I1_001.fastq", sample, lane);
        fs::copy(i1, &i1_new_filename)?;
        new_filenames.push(i1_new_filename);
    }

    if let Some(ref i2) = i2_file {
        let i2_new_filename = format!("{}_S1_{}_I2_001.fastq", sample, lane);
        fs::copy(i2, &i2_new_filename)?;
        new_filenames.push(i2_new_filename);
    }

    if let Some(ref r1) = r1_file {
        let r1_new_filename = format!("{}_S1_{}_R1_001.fastq", sample, lane);
        fs::copy(r1, &r1_new_filename)?;
        new_filenames.push(r1_new_filename);
    }

    if let Some(ref r2) = r2_file {
        let r2_new_filename = format!("{}_S1_{}_R2_001.fastq", sample, lane);
        fs::copy(r2, &r2_new_filename)?;
        new_filenames.push(r2_new_filename);
    }

    // Compress the new files with pigz
    for fastq in new_filenames {
        let pigz_status = Command::new("pigz")
            .arg("-p")
            .arg(args.cpu.to_string())
            .arg(&fastq)
            .status()?;

        if pigz_status.success() {
            println!("Successfully compressed: {}", fastq);
        } else {
            eprintln!("Failed to compress: {}", fastq);
        }
    }

    Ok(())
}
