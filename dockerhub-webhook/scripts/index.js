const scripts = {
  'honeypot': 'honeypot.sh',
  'ircd': 'ircd.sh',
  'virtual-temple': 'virtual-temple.sh',
  'webhook': 'webhook.sh',
  'zenbot': 'zenbot.sh'
}

module.exports = (repoName, tag) => {
  const hook = Object.keys(scripts)
    .find(key => {
      const regex = new RegExp(`^${key}$`, 'gm')
      const image = tag ? `${repoName}:${tag}` : repoName
      const match = image.match(regex)

      return match && match[0] === image
    })

  return scripts[hook]
}

