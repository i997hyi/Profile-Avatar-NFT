;; Profile Avatar NFT Contract
;; Implements a simple NFT minting and ownership-check function

(define-non-fungible-token avatar-nft uint)

(define-data-var total-supply uint u0)

;; Only one avatar per user (optional enforcement)
(define-map avatar-owner principal bool)

;; Errors
(define-constant err-already-minted (err u100))
(define-constant err-not-owner (err u101))

;; Mint function to create a new avatar NFT
(define-public (mint-avatar)
  (let (
        (token-id (var-get total-supply))
        (already-has (default-to false (map-get? avatar-owner tx-sender)))
       )
    (begin
      (asserts! (is-eq already-has false) err-already-minted)
      (try! (nft-mint? avatar-nft token-id tx-sender))
      (map-set avatar-owner tx-sender true)
      (var-set total-supply (+ token-id u1))
      (ok token-id)
    )
  )
)

;; Check if caller owns an avatar
(define-read-only (check-ownership (user principal))
  (ok (default-to false (map-get? avatar-owner user))))
