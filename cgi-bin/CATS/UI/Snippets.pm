package CATS::UI::Snippets;

use strict;
use warnings;

use CATS::Globals qw($cid $is_jury $is_root $sid $t);
use CATS::ListView;
use CATS::Messages qw(msg res_str);
use CATS::Output qw(url_f);
use CATS::DB;
use CATS::Web qw(param);

sub fields() {qw(id account_id problem_id contest_id text name)}

my $form = CATS::Form->new({
    table => 'snippets',
    fields => [ map +{ name => $_ }, fields() ],
    templates => { edit_frame => 'snippets_edit.html.tt' },
    href_action => 'snippets',
});

sub edit_frame {
    my ($p) = @_;
    $form->edit_frame($p, after => sub {
        $_[0]->{problems} = $dbh->selectall_arrayref(q~
            SELECT P.id AS "value", P.title AS text FROM problems P
            INNER JOIN contest_problems CP ON P.id = CP.problem_id
            WHERE CP.contest_id = ?~, { Slice => {} },
            $cid);

        $_[0]->{accounts} = $dbh->selectall_arrayref(q~
            SELECT A.id AS "value", A.login AS text FROM accounts A
            INNER JOIN contest_accounts CA ON A.id = CA.account_id
            WHERE CA.contest_id = ?~, { Slice => {} },
            $cid);
    });
}

sub edit_save {
    my ($p) = @_;
    $p->{contest_id} = $cid;

    my ($snippet_id) = $dbh->selectrow_array(q~
        SELECT id FROM snippets
        WHERE problem_id = ? AND account_id = ? AND contest_id = ? AND name = ?~, undef,
        @$p{qw(problem_id account_id contest_id name)}
    );
    return msg(1077, $p->{name}) if $snippet_id && $snippet_id != ($p->{id} // 0);

    $form->edit_save($p) and msg(1075, $p->{name});
}

sub snippet_frame {
    my ($p) = @_;

    $is_root or return;

    $form->edit_delete(id => $p->{delete}, descr => 'name', msg => 1076);
    $p->{edit_save} and edit_save($p);
    $p->{new} || $p->{edit} and return edit_frame($p);

    my $lv = CATS::ListView->new(
        name => 'snippets',
        template => 'snippets.html.tt');

    my @cols = (
        { caption => res_str(602), order_by => 'problem_name', width => '20%' },
        { caption => res_str(608), order_by => 'login', width => '20%' },
        { caption => res_str(601), order_by => 'name', width => '20%' },
        { caption => res_str(672), order_by => 'text', width => '40%' },
    );

    $lv->define_columns(url_f('snippets'), 0, 0, \@cols);
    $lv->define_db_searches([ fields() ]);

    my $sth = $dbh->prepare(q~
        SELECT
            S.id, S.name, S.problem_id, S.account_id,
            P.title AS problem_name,
            A.login, S.text
        FROM snippets S
        INNER JOIN contests C ON C.id = S.contest_id
        INNER JOIN problems P ON P.id = S.problem_id
        INNER JOIN accounts A ON A.id = S.account_id
        WHERE S.contest_id = ?
        ~ . $lv->order_by
    );
    $sth->execute($cid);


    my $fetch_record = sub {
        my $c = $_[0]->fetchrow_hashref or return ();
        return (
            %$c,
            href_delete => url_f('snippets', delete => $c->{id}),
            href_edit => url_f('snippets', edit => $c->{id}),
        );
    };

    $lv->attach(url_f('snippets'), $fetch_record, $sth);

    $sth->finish;

    $t->param(
        submenu => [ CATS::References::menu('snippets') ],
        editable => $is_root,
     );

}

1;