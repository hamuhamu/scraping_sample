use strict;
use warnings;
use v5.16;
use utf8;
use Encode;
use autodie;
use Web::Query;
use Data::Dumper;
use JSON qw (encode_json);
use constant {
    DIR => 'json',
    FILE_NAME => 'tds.json',
};

mkdir DIR unless -d DIR;
my $url = 'hogehoge.html';
my @jsons;

wq($url)
->find('tbody')
->each(sub {
        my(undef, $tbody) = @_;
        $tbody->find('tr')->each(sub {
                my(undef, $tr) = @_;
                my $td = $tr->find('td');

                my $td1 = encode('utf-8', $td->get(0)->as_text);
                my $td2 = encode('utf-8', $td->get(1)->as_text);
                my $td3 = encode('utf-8', $td->get(2)->as_text);

                my $json_txt = {
                    'td1' => $td1,
                    'td2' => $td2,
                    'td3' => $td3,
                };
                my $json = JSON->new->encode($json_txt);
                push @jsons, $json;
            });
    });

open(my $fh, '> ' . DIR . '/' . FILE_NAME);
foreach (@jsons) {
    say $fh $_;
}
close($fh);
