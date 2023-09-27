local Translations = {
    target = {
        label = 'Open MailBox'
    },
    notifies = {
        you_got = 'The Mailbox had %{items}',
        got_nothing = 'This Mailbox was empty',
        failed_minigame = 'You didnt get this Mailbox open.',
        canled_progress = 'You stopped searching the Mailbox.',
        already_dived = 'Theres no mail here',
    },
    progress = {
        diving = 'Prying open the mailbox',
    },
    police = {
        message = 'Suspicious Activity',
        code = '10-67',
        bliptitle = 'Mail Theft',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})