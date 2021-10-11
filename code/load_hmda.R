




pacman::p_load(tidyverse)




makeLARdata <- function(file, chunk_size){

  # get the year from the file name
  year <- str_extract_all(file, "[0-9]+")

  # 1980's
  if (as.numeric(year) < 90) { year = paste0("19", year) }

  # file name to export
  fname <- paste0("./data-prep/HMDA_LAR_", year, ".txt")

  # 1980's - want a "pre-format" suffix
  if (as.numeric(year) < 1990) { fname = gsub(".txt", "_PRE.txt", fname) }

  # DEFINE COLUMN TYPES & POSITIONS

  if (as.numeric(year) < 1990) {

    hmda_typs <- cols(
      .default = "c" # all cols are alphanumeric
    )

    hmda_cols <- fwf_cols(
      respondent_name = c(  1, 28),
      respondent_id   = c( 29, 36),
      msamd           = c( 37, 40),
      census_tract    = c( 41, 46),
      state_code      = c( 47, 48),
      county_code     = c( 49, 51),
      agency_code     = c( 52, 52),
      census_validity = c( 53, 54),
      flag_govt       = c( 55, 55),
      num_govt        = c( 56, 59),
      vol_govt        = c( 60, 68),
      flg_conv        = c( 69, 69),
      num_conv        = c( 70, 73),
      vol_conv        = c( 74, 82),
      flg_improv      = c( 83, 83),
      num_improv      = c( 84, 87),
      vol_improv      = c( 88, 96),
      flg_multi       = c( 97, 97),
      num_multi       = c( 98,101),
      vol_multi       = c(102,110),
      flg_nonocc      = c(111,111),
      num_nonocc      = c(112,115),
      vol_nunocc      = c(116,124),
      record_quality  = c(125,125)
    )

  } else if(as.numeric(year) < 2004) {

    hmda_typs <- cols(
      activity_year   = "i",
      sequence_number = "d",
      .default        = "c"
    )

    hmda_cols <- fwf_cols(
      activity_year       = c( 1, 4),
      respondent_id       = c( 5,14),
      agency_code         = c(15,15),
      loan_type           = c(16,16),
      loan_purpose        = c(17,17),
      occupancy_type      = c(18,18),
      loan_amount         = c(19,23),
      action_taken        = c(24,24),
      msamd               = c(25,28),
      state_code          = c(29,30),
      county_code         = c(31,33),
      census_tract        = c(34,40),
      applicant_race_1    = c(41,41),
      co_applicant_race_1 = c(42,42),
      applicant_sex       = c(43,43),
      co_applicant_sex    = c(44,44),
      income              = c(45,48),
      purchaser_type      = c(49,49),
      denial_reason_1     = c(50,50),
      denial_reason_2     = c(51,51),
      denial_reason_3     = c(52,52),
      edit_status         = c(53,53),
      sequence_number     = c(54,60)
    )

  } else if (year >= 2004) {

    hmda_typs <- cols(
      activity_year   = "i",
      sequence_number = "d",
      .default        = "c"
    )

    hmda_cols <- fwf_cols(
      activity_year          = c( 1, 4),
      respondent_id          = c( 5,14),
      agency_code            = c(15,15),
      loan_type              = c(16,16),
      loan_purpose           = c(17,17),
      occupancy              = c(18,18),
      loan_amount            = c(19,23),
      action_taken           = c(24,24),
      msamd                  = c(25,29),
      state_code             = c(30,31),
      county_code            = c(32,34),
      census_tract           = c(35,41),
      applicant_sex          = c(42,42),
      co_applicant_sex       = c(43,43),
      income                 = c(44,47),
      purchaser_type         = c(48,48),
      denial_reason_1        = c(49,49),
      denial_reason_2        = c(50,50),
      denial_reason_3        = c(51,61),
      edit_status            = c(52,52),
      property_type          = c(53,53),
      preapproval            = c(54,54),
      applicant_ethnicity    = c(55,55),
      co_applicant_ethnicity = c(56,56),
      applicant_race_1       = c(57,57),
      applicant_race_2       = c(58,58),
      applicant_race_3       = c(59,59),
      applicant_race_4       = c(60,60),
      applicant_race_5       = c(61,61),
      co_applicant_race_1    = c(62,62),
      co_applicant_race_2    = c(63,63),
      co_applicant_race_3    = c(64,64),
      co_applicant_race_4    = c(65,65),
      co_applicant_race_5    = c(66,66),
      rate_spread            = c(67,71),
      hoepa_status           = c(72,72),
      lien_status            = c(73,73),
      sequence_number        = c(74,80)
    )

  }

  # NOW READ THE FILES IN CHUNKS
  #  note: i could to this in sql but that is for later

  j = 0

  while(TRUE){

    # read in chunk
    chunk <- read_fwf(file,
                      col_positions = hmda_cols,
                      col_types     = hmda_typs,
                      skip          = j + 1,
                      n_max         = chunk_size)

    if (!nrow(chunk)) {
      break
    }

    # now write the file
    write_delim(chunk,
                fname,
                append    = T,
                delim     = "|",
                na        = "",
                col_names = !file.exists(fname))

    j = j + chunk_size

  }


}

# HMDA LAR files
file_list <- list.files("./data-prep/lar",
                        pattern = "HMD_FACDS",
                        full.names = T)

# now apply the function to each year
lapply(file_list, makeLARdata, chunk_size = 1e5)

# MAKE THE HMDA LAR -------------------------------------------------------

fix80data <- function(fname) {

  # ultimate file name
  fname_out = gsub("_PRE", "", fname)

  # read in new data
  dat <- read_delim(fname,
                    delim = "|",
                    col_types = cols(.default = "c")) %>%
    mutate(
      activity_year = as.numeric(str_extract_all(fname, "[0-9]+"))
    ) %>%
    # convert cols to numeric
    modify_at(8:23, as.numeric)

  # save the final file
  write_delim(dat,
              fname_out,
              delim = "|",
              na = "")

  # now clean up
  gc()

}



file_list <- list.files("./data-prep",
                        pattern = "._PRE.txt",
                        full.names = T)



lapply(file_list, fix80data)



# 2: PREP THE REPORTER PANEL AND TRANSMITTAL SHEET ------------------------

makeTSdata <- function(file){

  # get the year from the file name
  year <- str_extract_all(file, "[0-9]+")

  # file name to export
  fname_out <- paste0("./data-prep/HMDA_TS_", year, ".txt")

  # -----------------------------------------------------------------------
  # First we need to set up the correct column positions for each set of
  # years. The data contained in the transmittal sheet changes up a bit
  # in each year.
  # -----------------------------------------------------------------------

  if(as.numeric(year) < 1992) {

    hmda_typs <- cols(
      activity_year = "i",
      .default = "c"
    )

    hmda_cols <- fwf_cols(
      activity_year       = c(  1,  4),
      agency_code         = c(  5,  5),
      respondent_id       = c(  6, 15),
      respondent_name     = c( 16, 45),
      respondent_addr     = c( 46, 85),
      respondent_city     = c( 86,110),
      respondent_state    = c(111,112),
      respondent_zip_code = c(113,122),
      parent_name         = c(123,152),
      parent_addr         = c(153,192),
      parent_city         = c(193,217),
      parent_state        = c(218,219),
      parent_zip_code     = c(220,229),
      edit_status         = c(230,230)
    )

  } else if (as.numeric(year) %in% 1992:1997) {

    hmda_typs <- cols(
      activity_year = "i",
      .default = "c"
    )

    hmda_cols <- fwf_cols(
      activity_year       = c(  1,  4),
      agency_code         = c(  5,  5),
      respondent_id       = c(  6, 15),
      respondent_name     = c( 16, 45),
      respondent_addr     = c( 46, 85),
      respondent_city     = c( 86,110),
      respondent_state    = c(111,112),
      respondent_zip_code = c(113,122),
      parent_name         = c(123,152),
      parent_addr         = c(153,192),
      parent_city         = c(193,217),
      parent_state        = c(218,219),
      parent_zip_code     = c(220,229),
      edit_status         = c(230,230),
      tax_id              = c(231,240)
    )

  } else if (year %in% 1998:2003) {

    hmda_typs <- cols(
      activity_year = "i",
      .default = "c"
    )

    hmda_cols <- fwf_cols(
      activity_year       = c(  1,  4),
      agency_code         = c(  5,  5),
      respondent_id       = c(  6, 15),
      respondent_name     = c( 16, 45),
      respondent_addr     = c( 46, 85),
      respondent_city     = c( 86,110),
      respondent_state    = c(111,112),
      respondent_zip_code = c(113,122),
      edit_status         = c(123,123),
      tax_id              = c(124,133)
    )

  } else if (year %in% 2004:2006) {

    hmda_typs <- cols(
      activity_year = "i",
      .default = "c"
    )

    hmda_cols <- fwf_cols(
      activity_year       = c(  1,  4),
      agency_code         = c(  5,  5),
      respondent_id       = c(  6, 15),
      respondent_name     = c( 16, 45),
      respondent_addr     = c( 46, 85),
      respondent_city     = c( 86,110),
      respondent_state    = c(111,112),
      respondent_zip_code = c(113,122),
      parent_name         = c(123,152),
      parent_addr         = c(153,192),
      parent_city         = c(193,217),
      parent_state        = c(218,219),
      parent_zip_code     = c(220,229),
      edit_status         = c(230,230),
      tax_id              = c(231,240)
    )

  }

  # -----------------------------------------------------------------------
  # Next we need to load each fixed width file in using the above column
  # positions/types and export each file as a pipe-delimited text file.
  # After that the transmittal sheet is finished.
  # -----------------------------------------------------------------------

  # read in
  dat <- read_fwf(file, col_positions = hmda_cols, col_types = hmda_typs)

  # save the final file
  write_delim(dat, fname_out,
              delim = "|",
              na = "")

  rm(dat); gc()

}

# now apply the function
lapply(list.files("./data-prep/ts", pattern = ".zip", full.names = T),
       makeTSdata)



makePaneldata <- function(file) {

  # get the year from the file name
  year <- str_extract_all(file, "[0-9]+")

  # file name to export
  fname_out <- paste0("./data-prep/HMDA_PANEL_", year, ".txt")

  # -----------------------------------------------------------------------
  # First we need to set up the correct column positions for each set of
  # years. The data contained in the reporter panel also vary by reporting
  # year like the transmittal sheet. My column types differ slightly from
  # those specified in the NARA documentation. These are logical edits on
  # my part.  For instance, I keep the leading 0 in the reporter state FIPS
  # code
  # -----------------------------------------------------------------------

  if(as.numeric(year) %in% 1990:2003) {

    hmda_typs <- cols(
      msamd             = "i",
      agency_group      = "i",
      assets            = "d",
      other_lender_code = "i",
      activity_year     = "i",
      .default          = "c"
    )

    hmda_cols <- fwf_cols(
      respondent_id     = c(  1, 10),
      msamd             = c( 11, 14),
      agency_code       = c( 15, 15),
      agency_group      = c( 16, 17),
      respondent_name   = c( 18, 47),
      respondent_city   = c( 48, 72),
      respondent_state  = c( 73, 74),
      reporter_fips     = c( 75, 76),
      assets            = c( 77, 86),
      other_lender_code = c( 87, 87),
      parent_id         = c( 88, 97),
      parent_name       = c( 98,127),
      parent_city       = c(128,152),
      parent_state      = c(153,154),
      activity_year     = c(155,158)
    )

  } else if(as.numeric(year) %in% 2004:2006) {

    hmda_typs <- cols(
      msamd             = "i",
      agency_group      = "i",
      assets            = "d",
      other_lender_code = "i",
      activity_year     = "i",
      respondent_rssd   = "i",
      .default          = "c"
    )

    hmda_cols <- fwf_cols(
      respondent_id     = c(  1, 10),
      msamd             = c( 11, 15),
      agency_code       = c( 16, 16),
      agency_group      = c( 17, 18),
      respondent_name   = c( 19, 48),
      respondent_city   = c( 49, 73),
      respondent_state  = c( 74, 75),
      respondent_fips   = c( 76, 77),
      assets            = c( 78, 87),
      other_lender_code = c( 88, 88),
      parent_id         = c( 89, 98),
      parent_name       = c( 99,128),
      parent_city       = c(129,153),
      parent_state      = c(154,155),
      activity_year     = c(156,159),
      respondent_rssd   = c(160,169)
    )

  }

  # -----------------------------------------------------------------------
  # Next we need to load each fixed width file in using the above column
  # positions/types and export each file as a pipe-delimited text file.
  # After that the reporter panel is done
  # -----------------------------------------------------------------------

  # read in the panel
  dat <- read_fwf(file, col_positions = hmda_cols, col_types = hmda_typs)

  # now write the file
  write_delim(dat, fname_out,
              delim     = "|",
              na        = "")

  rm(dat); gc()

}

# now apply the function
lapply(list.files("./data-prep/panel", pattern = ".zip", full.names = T),
       makePaneldata)


















