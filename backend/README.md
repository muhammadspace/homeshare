# REST API Endpoints
## POST
| Endpoint            | Request Body                                                                                   | Response                                                                              | Notes                                                                                                                                                                                          |   |
|---------------------|------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---|
| `/recommend/owner`  | `target_user`: id of the user _**(need clarification on whose `id` it is)**_                   | JSON array of `{ "common_interests": decimal, "id": integer, "similarity": decimal }` | Response is an array of owners, sorted by `similarity`, from highest to lowest.                                                                                                                |   |
| `/recommend/seeker` | `seeker_id`: id of the seeker                                                                  | JSON array of `{ "apts": [], "common_interests": decimal, "id": integer}`.            | Response is an array of seekers, sorted by `common_interests`, from highest to lowest. _**(need clarification on what `id` refers to. Is it the owner of the apartments or another seeker?)**_ |   |
| `/login`            | `email` and `password`                                                                         | `{ status: true/false, success: success/failure message }`                            |                                                                                                                                                                                                |   |
| `/registration`     | `username`, `email`, `password`, `picture`, `dob`, `job`, `move_in_date`, `type`, and `gender` | `{ status: true/false, success: success/failure message }`                            |                                                                                                                                                                                                |   |

## GET


# TODO
- [ ] fix the Flask implementation of seeker recommendations such that it includes `apts`