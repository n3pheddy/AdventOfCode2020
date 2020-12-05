use strict;
use warnings;

my $input = 'var/aoc4_input.txt';

use constant EXPECTED_FIELDS => qw(
  byr iyr eyr hgt hcl ecl pid
);

=pod
Returns an array of expected fields.
=cut
sub array_from_expected_fields {
  return (EXPECTED_FIELDS)[0..6];
}

sub validate_byr {
  my $byr = int(shift);
  return ($byr >= 1920 and $byr <= 2002);
};

sub validate_iyr {
  my $iry = int(shift);
  return ($iry >= 2010 and $iry <= 2020);
}

sub validate_eyr {
  my $ery = int(shift);
  return ($ery >= 2020 and $ery <= 2030);
}

sub validate_hgt {
  my $hgt = shift;
  my ($value, $unit) = ($hgt =~ m/^(\d*)(cm|in)$/);

  return 0 if not defined $unit;

  if ($unit eq 'cm') {
    return ($value >= 150 and $value <= 193);
  }
  elsif ($unit eq 'in') {
    return ($value >= 59 and $value <= 76);
  }
}

sub validate_hcl {
  my $hcl = shift;
  return $hcl =~ m/^#[0-9a-f]{6}$/;
}

sub validate_ecl {
  my $ecl = shift;
  return $ecl =~ m/^amb|blu|brn|gry|grn|hzl|oth$/;
}

sub validate_pid {
  my $pid = shift;
  return $pid =~ m/^\d{9}$/;
}

=pod
Mapping from field name to a validation subroutine.
=cut
my %validate_fns = (
  'byr' => \&validate_byr,
  'iyr' => \&validate_iyr,
  'eyr' => \&validate_eyr,
  'hgt' => \&validate_hgt,
  'hcl' => \&validate_hcl,
  'ecl' => \&validate_ecl,
  'pid' => \&validate_pid,
);

=pod
Method that takes in a flag for whether to perform value validation,
and an array consisting of each line in the input file. Returns the
number of valid entries. Entries are separated by an empty line.

Time complexity : O(n)
Space complecity: O(1)
Where n = scalar @lines
=cut
sub validate_passports {
  my ($validate_value, @lines) = @_;
  my @fields_left = array_from_expected_fields();
  my $total_valid = 0;
  my $this_valid = 1;

  foreach (@lines) {
    my $line = $_;
    if ($line eq "") {
      if ($this_valid and scalar @fields_left == 0) {
        $total_valid += 1;
      }

      @fields_left = array_from_expected_fields();
      $this_valid = 1;
    }
    elsif ($this_valid) {
      my @tokens = split / /, $line;

      foreach (@tokens) {
        my @field_values = split /:/, $_;
        my $field_name = $field_values[0];
        my $field_value = $field_values[1];

        if ($validate_value and ref $validate_fns{$field_name}) {
          $this_valid = $validate_fns{$field_name}->($field_value);

          if (not $this_valid) {
            last;
          }
        }

        @fields_left = grep { $_ ne $field_name } @fields_left;
      }
    }
  }

  return $total_valid;
}

open my $handle, '<', $input or die $!;
chomp(my @lines = <$handle>);
close $handle;

my $check_field_exist_total = validate_passports(0, @lines);
my $validated_field_total = validate_passports(1, @lines);

print("Number of passports with required fields: $check_field_exist_total\n");
print("Number of passports with validated fields: $validated_field_total\n");