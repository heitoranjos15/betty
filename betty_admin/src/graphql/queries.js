import gql from 'graphql-tag';

export const GET_GAMES_BY_TEAM_NAME = gql`
  query GetGamesByTeamName($teamName: String!) {
    gamesByTeamName(teamName: $teamName) {
      map
      externalId
      gameData {
        startTimestamp
        winner
        teams {
          name
          teamId
          side
          towers
          gold

          kills
        }
        gameDuration
      }
      playerData {
        champion
      }
    }    
  }
`;

export const GET_GAMES_BY_TEAM_EXTERNAL_ID = gql`
query GetGamesByTeamExternalId($externalId: String!) {
  gameDataByTeamId(teamId: $externalId) {
    map
    externalId
    gameData {
      startTimestamp
      winner
      patchVersion
      teams {
        name
        code
        teamId
        externalId
        side
        towers
        gold
        kills
        dragons
      }
      gameDuration
    }
    playerData {
      name
      champion
      kills
      deaths
      assists
      totalGoldEarned
      creepScore
    }
  }    
}
`;

export const GET_TEAMS = gql`
query GetTeams($name: String) {
  teams(name: $name) {
      name
      externalId
    }
  }
`;
