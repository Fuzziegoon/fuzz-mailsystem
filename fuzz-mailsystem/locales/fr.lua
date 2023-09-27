local Translations = {
    target = {
        label = 'Fouiller'
    },
    notifies = {
        you_got = 'Vous avez fouillé la poubelle et avez trouvé %{items}',
        got_nothing = 'Vous avez fouillé la poubelle et n\'avez rien trouvé',
        failed_minigame = 'Vous n\'avez pas été capable de fouiller le conteneur.',
        canled_progress = 'Vous avez annulé la fouille.',
        hurt_yourself = 'Vous vous êtes blessé en fouillant.',
        already_dived = 'Cette poubelle à déjà été fouillé.',
    },
    progress = {
        diving = 'Plongé dans une poubelle',
    },
    police = {
        message = 'Activité Criminel',
        code = '10-00',
        bliptitle = 'Plongé de Poubelle',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})