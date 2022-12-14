write_to_file <- function(s1, s2) {
  seq1 <- tempfile("seq1")
  seq2 <- tempfile("seq2")
  write(s1, seq1)
  write(s2, seq2)
  c(seq1, seq2)
}
# parse the output of EMBOSS needle
parse_needle <- function(otfile) {
  lst <- readLines(otfile)
  similarity <- stringr::str_extract_all(lst[stringr::str_detect(lst, "Similarity:")], "[\\d\\(\\)%\\.\\/]+", simplify = T)
  similarity <- as.character(similarity)
  score <- as.numeric(stringr::str_extract_all(lst[stringr::str_detect(lst, "Score:")], "[\\d\\.]+", simplify = T))
  lst2 <- lst[!(stringr::str_detect(lst, "#") | (lst == ""))]
  lst3 <- na.omit(stringr::str_extract(lst2, "[AGCTN-]+"))
  subject <- paste0(lst3[seq(1, length(lst3), 2)], collapse = "")
  pattern <- paste0(lst3[seq(2, length(lst3), 2)], collapse = "")
  list(similarity = paste(similarity, collapse = " "), score = score, subject = subject, pattern = pattern)
}

needle <- function(s1, s2, gapopen = 10, gapextend = 0.5, exe_path = "/home/panxiaoguang/app/EMBOSS-6.6.0/EMBOSS/bin/needle") {
  otfile <- tempfile("needle")
  tmpfiles <- write_to_file(s1, s2)
  ags <- c("-asequence", tmpfiles[1], "-bsequence", tmpfiles[2], "-gapopen", gapopen, "-gapextend", gapextend, "-outfile", otfile)
  callbak <- sys::exec_internal(exe_path, args = ags)
  if (callbak$status == 0) {
    rst1 <- parse_needle(otfile)
  } else {
    print("Some error happend!")
  }
  file.remove(otfile)
  file.remove(tmpfiles)
  ### use reverse align
  otfile <- tempfile("needle")
  s1_r <- as.character(Biostrings::reverseComplement(Biostrings::DNAString(s1)))
  tmpfiles <- write_to_file(s1_r, s2)
  ags <- c("-asequence", tmpfiles[1], "-bsequence", tmpfiles[2], "-gapopen", gapopen, "-gapextend", gapextend, "-outfile", otfile)
  callbak <- sys::exec_internal(exe_path, args = ags)
  if (callbak$status == 0) {
    rst2 <- parse_needle(otfile)
  } else {
    print("Some error happend!")
  }
  file.remove(otfile)
  file.remove(tmpfiles)
  if (rst1$score > rst2$score){
    return(rst1)
  }else{
    return(rst2)
  }
}

