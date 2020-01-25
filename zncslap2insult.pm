# zncslap2insult.pm v1.0 by Sven Roelse
# Copycat idea: https://github.com/0x27/irssi-shakespeare-insult

# 24-01-2020 - v1.0 first draft

use strict;
use warnings;
use diagnostics;
use utf8;

use POE::Component::IRC::Common;

package zncslap2insult;
use base 'ZNC::Module';

my @c1 = qw(artless bawdy beslubbering bootless churlish cockered 
clouted craven currish dankish dissembling droning errant
fawning fobbing froward frothy gleeking goatish gorbellied
impertinent infectious jarring loggerheaded lumpish mammering
mangled mewling paunchy pribbling puking puny qualling
rank reeky rogueish ruttish saucy spleeny spongy surly 
tottering unmuzzled vain venomed villainous warped wayward 
weedy yeastly);

my @c2 = qw(base-court bat-fowling beef-witted beetle-headed boil-brained
clapper-clawed clay-brained common-kissing crook-pated dismal-dreaming
dizzy-eyed doghearted dread-bolted earth-vexing elf-skinned fat-kidneyed
fen-sucked flap-mouthed fly-bitten folly-fallen fool-born full-gorged
guts-griping half-faced hasty-witted hedge-born hell-hated idle-headed
ill-breeding ill-nurtured knotty-pated milk-livered motley-minded onion-eyed
plume-plucked pottle-deep pox-marked reeling-ripe rough-hewn rude-growing
rump-fed shard-borne sheep-biting spur-galled swag-bellied tardy-gaited
tickle-brained toad-spotted unchin-snouted weather-bitten);

my @c3 = qw(apple-john baggage barnacle bladder boar-pig bugbear bum-bailey
canker-blossom clack-dish clotpole coxcomb codpiece death-token dewberry
flap-dragon flax-wench flirt-gill foot-licker fustilarian giglet gudgeon
haggard harpy hedge-pig horn-beast hugger-mugger joithead lewdster lout
maggot-pie malt-worm mammet measle minnow miscreant moldwarp mumble-news
nut-hook pidgeon-egg pignut puttock pumpion ratsbane scut skainsmate
strumpet varlot vassal whey-face wagtail);

sub description {
    "Auto shakespearian-insult on slap!"
}

sub module_types {
    $ZNC::CModInfo::UserModule
}

sub put_chan {
    my ($self, $chan, $msg) = @_;
    $self->PutIRC("PRIVMSG $chan :$msg");
}

sub OnChanAction {
    my ($self, $nick, $chan, $message) = @_;
    $nick = $nick->GetNick;
    $chan = $chan->GetName;
    
    my $MyNick = $self->GetNetwork()->GetIRCSock->GetNick();

    # Strip colors and formatting
    if (POE::Component::IRC::Common::has_color($message)) {
        $message = POE::Component::IRC::Common::strip_color($message);
    }
    if (POE::Component::IRC::Common::has_formatting($message)) {
        $message = POE::Component::IRC::Common::strip_formatting($message);
    }
    if ($message=~/^slaps\s+\Q$MyNick\E(.*)$/i) {
        $self->put_chan($chan,"$nick, thou $c1[rand @c1] $c2[rand @c2] $c3[rand @c3]!");
    }

    return $ZNC::CONTINUE;
}
1;
